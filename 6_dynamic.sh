helm delete --purge mybb

docker build . -f docker/6_Dockerfile -t localhost:5000/mybb:6_dynamic
docker push localhost:5000/mybb:6_dynamic

#rm -Rf consul/helm
#git clone --branch v0.1.0 https://github.com/hashicorp/consul-helm.git consul/helm
helm install -f consul/values.yaml --name configuration consul/helm

# Wait for the Consul Server pod to come up (the lazy sleepy way)
echo "\nWaiting for Consul to become available...\n"
sleep 15
export CONSUL_POD=configuration-consul-server-0
kubectl port-forward $CONSUL_POD 8500:8500 &

consul kv put mybb/php/database/driver mysqli
consul kv put mybb/mysql/hostname database-mysql.default.svc.cluster.local
consul kv put mybb/mysql/schema mybb
consul kv put mybb/mysql/table_prefix mybb_
consul kv put mybb/mysql/encoding utf8
consul kv put mybb/mysql/credentials/username mybb
consul kv put mybb/cache/store memcached
consul kv put mybb/cache/memcache/host cache-memcached.default.svc.cluster.local
consul kv put mybb/cache/memcache/port 11211
consul kv put apache/networking/timeout 300
consul kv put apache/networking/keepalive On
consul kv put apache/networking/keepalive_requests 100
consul kv put apache/networking/keepalive_timeout 5
consul kv put apache/log_level warn

#rm -Rf vault/helm
#git clone https://github.com/helm/charts /tmp/helm-charts
#mv /tmp/helm-charts/incubator/vault vault/helm
helm install --name=secrets --set replicaCount=1 vault/helm

echo "\nWaiting for Vault to become available...\n"
sleep 10 # Wait for the Vault Server pod to come up (the lazy sleepy way)
export VAULT_POD=$(kubectl get pods --namespace default -l "app=vault" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $VAULT_POD 8200:8200 &

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=$(kubectl logs $VAULT_POD | grep 'Root Token' | cut -d' ' -f3)

kubectl create serviceaccount vault-auth
kubectl apply --filename vault/vault-auth-service-account.yml

vault kv put secret/mybb/mysql/credentials password="mybb"




# Set VAULT_SA_NAME to the service account you created earlier
export VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")

# Set SA_JWT_TOKEN value to the service account JWT used to access the TokenReview API
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)

# Set SA_CA_CRT to the PEM encoded CA cert used to talk to Kubernetes API
export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

export K8S_HOST=$(kubectl exec $CONSUL_POD -- sh -c 'echo $KUBERNETES_SERVICE_HOST')

vault policy write mybb-kv-readonly vault/mybb-kv-readonly.hcl

vault auth enable kubernetes

vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://$K8S_HOST:443" \
  kubernetes_ca_cert="$SA_CA_CRT"

vault write auth/kubernetes/role/mybb \
  bound_service_account_names=vault-auth \
  bound_service_account_namespaces=default \
  policies=mybb-kv-readonly \
  ttl=24h

helm install --name=mybb ./helm/dynamic

echo "Tailing logs of the MyBB deployment..."
stern --selector app=mybb

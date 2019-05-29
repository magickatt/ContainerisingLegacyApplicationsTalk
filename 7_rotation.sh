echo "\Stopping MyBB deployment"
sleep 1
helm delete --purge mybb
pkill kubectl

echo "\nBuilding MyBB Docker image"
sleep 1
docker build . -f docker/7_Dockerfile -t localhost:5000/mybb:7_rotation
docker push localhost:5000/mybb:7_rotation

export VAULT_POD=$(kubectl get pods --namespace default -l "app=vault" -o jsonpath="{.items[0].metadata.name}")
# kubectl port-forward $VAULT_POD 8200:8200 &
export CONSUL_POD=configuration-consul-server-0
# kubectl port-forward $CONSUL_POD 8500:8500 &

export VAULT_TOKEN=$(kubectl logs $VAULT_POD | grep 'Root Token' | cut -d' ' -f3)

# vault secrets enable database

MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

echo "\Configuring Vault policies"
sleep 1

vault write database/config/mybb \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(database-mysql:3306)/" \
  allowed_roles="mybb" \
  username="root" \
  password="$MYSQL_ROOT_PASSWORD"

vault write database/roles/mybb \
    db_name=mybb \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON mybb.* TO '{{name}}'@'%';" \
    default_ttl="2m" \
    max_ttl="3m"


echo "\Configuring Consul external services"
sleep 1
curl --request PUT --data @consul/database.json localhost:8500/v1/catalog/register\
curl --request PUT --data @consul/cache.json localhost:8500/v1/catalog/register

echo "\nDeploying MyBB to Kubernetes"
sleep 1
#helm install --dry-run --debug --set mybb.image.tag=7_rotation ./helm/dynamic
helm install --name=mybb --set mybb.image.tag=7_rotation ./helm/dynamic

echo "Tailing logs of the MyBB deployment..."
stern --selector app=mybb

# Containerising legacy applications talk

## Setup

		git clone --depth=1 --branch=mybb_1820 https://github.com/mybb/mybb.git application
		rm -rf ./application/.git

## 1

### Run

		docker build . -t mybb:latest
    docker run -p 80:80 mybb:latest

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

		<!-- kubectl create secret generic regcred \
		    --from-file=".dockerconfigjson=/Users/magickatt/.docker/config.json" \
		    --type=kubernetes.io/dockerconfigjson
		secret/regcred created -->

		kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=magickatt --docker-password=[password] --docker-email=a.kirkpatrick@rocketmail.com

## 2 - Kubernetes

## Configmap

### Create configmap

kubectl create configmap mybb-configmap --from-file=configuration/settings.php --from-file=configuration/config.php

### Update configmap

kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-fileconfiguration/config.php -o yaml --dry-run | kubectl replace -f -

https://stackoverflow.com/questions/38216278/update-k8s-configmap-or-secret-without-deleting-the-existing-one

ln -s /var/www/config/config.php /var/www/html/mybb/inc/config.php
ln -s /var/www/config/settings.php /var/www/html/mybb/inc/settings.php

## 2 - Nomad

sudo ssh -p 2222 -i ~/.vagrant.d/insecure_private_key -N -L \
 80:localhost:80 \
 vagrant@localhost

## 3

### Consul

https://learn.hashicorp.com/consul/getting-started-k8s/minikube

https://github.com/helm/charts/tree/master/incubator/vault
 replicaCount: 1



kubectl exec -it singed-flee-consul-qptx9 /bin/sh

consul kv put mybb/boardclosed 0
consul kv get mybb/boardclosed





### Vault


export VAULT_POD=$(kubectl get pods --namespace default -l "app=vault" -o jsonpath="{.items[0].metadata.name}")
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=$(kubectl logs $VAULT_POD | grep 'Root Token' | cut -d' ' -f3)

kubectl create serviceaccount vault-auth
kubectl apply --filename k8s_2/vault-auth-service-account.yml

vault kv put secret/mybb/test password="pizza"




vault write auth/userpass/users/mybb-qa \
        password=qual1ty \
        policies=mybb-kv-readonly

vault login -method=userpass \
        username=mybb-qa \
        password=qual1ty






#### Experimental
s.6laGe4Pg5haJlPzcqSbGJp83
export VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export K8S_HOST=$(kubectl exec singed-flee-consul-server-0 -- sh -c 'echo $KUBERNETES_SERVICE_HOST')

vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://$K8S_HOST:443" \
  kubernetes_ca_cert="$SA_CA_CRT"

	curl -X GET \
	  http://localhost:8200/v1/secret/data/mybb/test \
	  -H 'x-vault-token: xxx'

http://localhost:8200/v1/secret/data/mybb/test

### MySQL

CREATE SCHEMA `mybb` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

# Containerizing legacy applications

Contains code for all the demonstrations in the *Containerizing legacy applications with dynamic file-based configurations and secrets* talk that I delivered at DevOps Days Toronto 2019 and DevOps Days Boston 2019.

## Pre-requisites

To run the demos you will need the following software installed

* [Docker](https://docs.docker.com/install)
* [Kubernetes](https://blog.docker.com/2018/07/kubernetes-is-now-available-in-docker-desktop-stable-channel)
* [Stern](https://github.com/wercker/stern) (tail multiple k8s pod logs)

## Demo 0, Run MyBB locally

### Run

    ./0_local.sh

### Video

![videos/Demo_0_Local.mp4](videos/thumbs/Demo_0_Local.gif)

[Demo 0 video on Vimeo](https://vimeo.com/358959423)

### Notes

## Demo 1, Run MyBB in a single Docker container

Outcome of this demo is to show a basic Docker image build and that MyBB runs on a local Docker host (with some caveats)

### Run

    ./1_docker.sh

### Video

![videos/Demo_1_Docker.mp4](videos/thumbs/Demo_1_Docker.gif)

[Demo 1 video on Vimeo](https://vimeo.com/357978539)

### Notes

	git clone --depth=1 --branch=mybb_1820 https://github.com/mybb/mybb.git application
	rm -rf ./application/.git

	docker build . -t mybb:latest
   docker run -p 80:80 mybb:latest

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

		<!-- kubectl create secret generic regcred \
		    --from-file=".dockerconfigjson=/Users/magickatt/.docker/config.json" \
		    --type=kubernetes.io/dockerconfigjson
		secret/regcred created -->

		kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=magickatt --docker-password=[password] --docker-email=a.kirkpatrick@rocketmail.com

## Demo 2, Run MyBB in multiple containers using Docker Compose

### Run

    ./2_compose.sh
    
### Video

![videos/Demo_2_Compose.mp4](videos/thumbs/Demo_2_Compose.gif)

[Demo 2 video on Vimeo](https://vimeo.com/358958970)

### Notes

Coming soon...

## Demo 3, Run MyBB in multiple containers using Docker Swarm

### Run

    ./3_swarm.sh
    
### Video

![videos/Demo_3_Swarm.mp4](videos/thumbs/Demo_3_Swarm.gif)

[Demo 3 video on Vimeo](https://vimeo.com/358959390)

### Notes

Coming soon...

## Demo 4, Run MyBB in multiple containers using Kubernetes

### Run

    ./4_k8s.sh
    
### Video

![videos/Demo_4_k8s.mp4](videos/thumbs/Demo_4_k8s.gif)

[Demo 4 video on Vimeo](https://vimeo.com/358959402)

### Notes

Coming soon...

## Demo 5, Install MyBB and dependent services using Helm

### Run

    ./5_helm.sh
    
### Video

![videos/Demo_5_Helm.mp4](videos/thumbs/Demo_5_Helm.gif)

[Demo 5 video on Vimeo](https://vimeo.com/358959408)

### Notes

Coming soon...

## Demo 6, Run MyBB with Consul and Vault KV

### Run

    ./6_dynamic.sh
    
### Video

![videos/Demo_6_Dynamic.mp4](videos/thumbs/Demo_6_Dynamic.gif)

[Demo 6 video on Vimeo](https://vimeo.com/358961230)

### Notes

Coming soon...

## Demo 7, Run MyBB with Consul ESM and Vault database secrets engine

### Run

    ./7_rotation.sh
    
### Video

![videos/Demo_7_Rotation.mp4](videos/thumbs/Demo_7_Rotation.gif)

[Demo 7 video on Vimeo](https://vimeo.com/358959419)

### Notes

Coming soon...





## 2 - Kubernetes

https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/#deploy-mysql

## Configmap

### Create configmap

kubectl create configmap mybb-configmap --from-file=configuration/settings.php --from-file=configuration/config.php

### Update configmap

kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file configuration/config.php -o yaml --dry-run | kubectl replace -f -

https://stackoverflow.com/questions/38216278/update-k8s-configmap-or-secret-without-deleting-the-existing-one

ln -s /var/www/config/config.php /var/www/html/mybb/inc/config.php
ln -s /var/www/config/settings.php /var/www/html/mybb/inc/settings.php

### Docker credentials

	kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=[username] --docker-password=[password] --docker-email=[email]

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











#### Live Demonstration quick command reference

Replace from-file ConfigMap information

````
kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file \
configuration/config_k8s.php -o yaml --dry-run | kubectl replace -f -
````

Force a pod to destroy

````
kubectl delete pod [name] --grace-period=0 --force
````

List items in memcache

````
echo "stats items" | ncat 127.0.0.1 11211
````


export PATH=$PATH:/Applications/MySQL\ Workbench.app/Contents/MacOS

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

https://learn.hashicorp.com/consul/getting-started-k8s/minikube

https://github.com/helm/charts/tree/master/incubator/vault
 replicaCount: 1



kubectl exec -it singed-flee-consul-qptx9 /bin/sh

consul kv put mybb/boardclosed 0
consul kv get mybb/boardclosed

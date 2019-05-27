# Containerising legacy applications talk

## Pre-requisites

### Install

* [Stern](https://github.com/wercker/stern) for tailing multiple pod logs
* [Helm client](https://helm.sh/docs/using_helm/#installing-the-helm-client)
* [Docker](https://docs.docker.com/install)
* Kubernetes
 * Via [Docker for Mac](https://docs.docker.com/docker-for-mac/kubernetes/) (tested)
 * [Minikube](https://kubernetes.io/docs/setup/minikube)*

\* _Currently there are default values for the Helm charts that point to the Docker for Mac host to access the local Docker registry from Kubernetes, so you will need to override this as appropriate_

### Configuration

#### Initialise Helm

````
helm init --history-max 200
````

#### Create a local Docker registry

````
docker run -d -p 5000:5000 --restart=always --name registry registry:2
````

## Step 0, run locally

````
./0_run.sh
````

## Step 1, run in Docker

````
./1_docker.sh
````

## Step 2, run using Docker Compose

````
./2_compose.sh
````

## Step 3, run using Docker Swarm

````
./3_swarm.sh
````

## Step 4, run in Kubernetes

````
./4_k8s.sh
````

## Step 5, deploy using Helm

````
./5_helm.sh
````

## Step 6, configure using Consul and Vault

````
./6_dynamic.sh
````

## Step 7, dynamic configuration

````
./7_rotation.sh
````

## Consul

https://learn.hashicorp.com/consul/getting-started-k8s/minikube

https://github.com/helm/charts/tree/master/incubator/vault
 replicaCount: 1

## Quick command reference

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

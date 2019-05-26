# Cleanup from previous demo runs
kubectl delete statefulsets,replicasets,services,deployments,pods,rc,pv,pvc --all
pkill kubectl
helm ls --all --short | xargs -L1 helm delete --purge
docker kill $(docker ps -q)
docker swarm leave --force

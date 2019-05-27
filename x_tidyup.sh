# Cleanup from previous demo runs
pkill kubectl
kubectl delete statefulsets,replicasets,services,deployments,pods,rc,pv,pvc --all
helm ls --all --short | xargs -L1 helm delete --purge
docker kill $(docker ps -q)
docker swarm leave --force

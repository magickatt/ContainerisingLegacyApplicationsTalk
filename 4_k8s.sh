# Delete the Docker Swarm Stack created in Step 3
docker stack rm mybb

#kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=magickatt --docker-password=[password] --docker-email=youremail@email.com

# Create the configmap
kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file configuration/config.php
kubectl apply -f k8s/
#kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file
# configuration/config.php -o yaml --dry-run | kubectl replace -f -

kubectl port-forward mysql-0 3306:3306

# Delete the Docker Swarm Stack created in Step 3
echo "Stopping Docker Swarm deployment"
sleep 30
docker stack rm mybb

# Create the configmap
echo "\nCreating MyBB configuration as ConfigMap"
sleep 1
kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file configuration/config_k8s.php

echo "\nDeploying MyBB and MySQL to Kubernetes"
sleep 1
kubectl apply -f k8s/

echo "\nInspecting MyBB and MySQL pods"
kubectl get pods
# kubectl create configmap mybb-configmap --from-file configuration/settings.php --from-file \
# configuration/config_k8s.php -o yaml --dry-run=client | kubectl replace -f -

echo "\nImporting data into MySQL"
sleep 45
kubectl port-forward mysql-0 3306:3306 &
sleep 5
mysql -h 127.0.0.1 -u root < database/mybb.sql

echo "\nTailing the logs..."
stern --selector app=mybb

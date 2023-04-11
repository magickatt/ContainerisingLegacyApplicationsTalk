echo "Stopping Kubernetes deployments"
kubectl delete deployment mybb-deployment
kubectl delete service mybb-service
kubectl delete statefulset mysql
kubectl delete pv,pvc --all &

echo "\nBuilding MyBB Docker image"
docker build . -f docker/5_Dockerfile -t localhost:5000/mybb:5_helm
docker push localhost:5000/mybb:5_helm

# Install MySQL via Helm
echo "\nDeploying MySQL to Kubernetes"
# MYSQL_ROOT_PASSWORD=">-0URS4F3P4SS"
# helm repo add mysql-operator https://mysql.github.io/mysql-operator/
# helm repo update
# helm install mysql-operator mysql-operator/mysql-operator \
#    --namespace mysql-operator --create-namespace
# helm install database mysql-operator/mysql-innodbcluster \
#         --version 2.0.8 \
#         --set credentials.root.password="$MYSQL_ROOT_PASSWORD" \
#         --set tls.useSelfSigned=true

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install database bitnami/mysql
sleep 1

echo "\nImporting data into MySQL"
sleep 30
MYSQL_POD=$(kubectl get pods -l "app.kubernetes.io/instance=database" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $MYSQL_POD 3306:3306 &
sleep 5
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
echo "\nMySQL root password is $MYSQL_ROOT_PASSWORD (this is a demo)"
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql

# Install Memcache via Helm
echo "\nDeploying Memcache to Kubernetes"
sleep 1
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install cache bitnami/memcached
# helm install --name cache --set replicaCount=1 stable/memcached

# Install MyBB via Helm
echo "\nDeploying MyBB to Kubernetes"
sleep 1
helm install mybb ./helm/standard

#kubectl port-forward cache-memcached-0 11211:11211 &
#echo "stats items" | ncat 127.0.0.1 11211

sleep 15
echo "\nTailing the logs..."
stern --selector app=mybb

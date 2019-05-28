#kubectl delete statefulsets,replicasets,services,deployments,pods,rc,pv,pvc --all --force --grace-period=0

# Initialise Helm
#helm init --history-max 200

# Install MySQL via Helm
echo "\nDeploying MySQL to Kubernetes"
sleep 1
helm install --name database stable/mysql
MYSQL_POD=$(kubectl get pods --namespace default -l "app=database-mysql" -o jsonpath="{.items[0].metadata.name}")

echo "\nImporting data into MySQL"
sleep 45
kubectl port-forward $MYSQL_POD 3306:3306 &
sleep 5
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
echo "\nMySQL root password is $MYSQL_ROOT_PASSWORD (this is a demo, get over it)"
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql

# Install Memcache via Helm
echo "\nDeploying Memcache to Kubernetes"
sleep 1
helm install --name cache stable/memcached

# Install MyBB via Helm
echo "\nDeploying MyBB to Kubernetes"
sleep 1
helm install --dry-run --debug ./helm/standard
helm install --name=mybb ./helm/standard

#kubectl port-forward cache-memcached-0 11211:11211 &
#echo "stats items" | ncat 127.0.0.1 11211

echo "\nTailing the logs..."
stern --selector app=mybb

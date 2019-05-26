kubectl delete statefulsets,replicasets,services,deployments,pods,rc,pv,pvc --all

# Initialise Helm
helm init --history-max 200

# Install MySQL via Helm
echo "Deploying MySQL"
helm install --name database stable/mysql
MYSQL_POD=$(kubectl get pods --namespace default -l "app=database-mysql" -o jsonpath="{.items[0].metadata.name}")

echo "Importing data into MySQL"
sleep 45
kubectl port-forward $MYSQL_POD 3306:3306
sleep 5
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql

# Install Memcache via Helm
echo "Deploying Memcache"
helm install --name mybb-memcache stable/memcached

# Install MyBB via Helm
echo "Deploying MyBB"
helm install --dry-run --debug ./helm
helm install --name=5_helm ./helm
echo "Deploying MySQL"

#kubectl port-forward mybb-memcache-memcached-0 11211:11211
#echo "stats items" | ncat 127.0.0.1 11211

echo "Tailing logs of the MyBB deployment..."
stern --selector app=mybb

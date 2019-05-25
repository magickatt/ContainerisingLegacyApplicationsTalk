# Initialise Helm
helm init --history-max 200

# Install MySQL via Helm
helm install --name database stable/mysql
MYSQL_POD=$(kubectl get pods --namespace default -l "app=database-mysql" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $MYSQL_POD 3306:3306
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql

# Install Memcache via Helm
helm install --name mybb-memcache stable/memcached

# Install MyBB via Helm
helm install --dry-run --debug ./helm
helm install --name=5_helm ./helm

#kubectl port-forward mybb-memcache-memcached-0 11211:11211
#echo "stats items" | ncat 127.0.0.1 11211

echo "Tailing logs of the MyBB deployment..."
stern --selector app=mybb

kubectl delete deployment mybb-deployment
kubectl delete statefulset mysql
kubectl delete pv,pvc --all

docker build . -f docker/5_Dockerfile -t localhost:5000/mybb:5_helm
docker push localhost:5000/mybb:5_helm

# Install MySQL via Helm
echo "Deploying MySQL"
helm install --name database stable/mysql

echo "Importing data into MySQL"
sleep 45
MYSQL_POD=$(kubectl get pods --namespace default -l "app=database-mysql" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $MYSQL_POD 3306:3306 &
sleep 5
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
echo "MySQL root password is $MYSQL_ROOT_PASSWORD"
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql

# Install Memcache via Helm
echo "Deploying Memcache"
helm install --name cache stable/memcached

# Install MyBB via Helm
echo "Deploying MyBB"
helm install --dry-run --debug ./helm/standard
helm install --name=mybb ./helm/standard

kubectl port-forward cache-memcached-0 11211:11211 &
#echo "stats items" | ncat 127.0.0.1 11211

sleep 15

echo "Tailing logs of the MyBB deployment..."
stern --selector app=mybb

helm init --history-max 200
helm install --dry-run --debug ./helm

helm install --name=5_helm ./helm




helm install --name mybb stable/mysql
kubectl port-forward mysql-0 3306:3306
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default mybb-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)
mysql -h 127.0.0.1 -u root -p$MYSQL_ROOT_PASSWORD < database/mybb.sql


helm install --name mybb stable/memcached

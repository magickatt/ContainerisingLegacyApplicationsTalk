vault secrets enable database

MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default database-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

vault write database/config/mybb \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(database-mysql:3306)/" \
  allowed_roles="mybb" \
  username="root" \
  password="$MYSQL_ROOT_PASSWORD"

vault write database/roles/mybb \
    db_name=mybb \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON mybb.* TO '{{name}}'@'%';" \
    default_ttl="1m" \
    max_ttl="2m"

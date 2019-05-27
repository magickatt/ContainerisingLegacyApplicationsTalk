docker-compose -f docker/docker-compose.yml down

docker swarm init
docker stack deploy --compose-file docker/docker-swarm.yml mybb
docker stack services mybb

echo "Importing data into MySQL"
# Wait for the MySQL container to come up (the lazy sleepy way)
sleep 45
mysql -h 127.0.0.1 -u root -pexample < database/mybb.sql

docker stack services -q mybb | xargs -L1 -I{} sh -c 'docker service logs -f {} &'

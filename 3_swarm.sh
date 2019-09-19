echo "Stopping MyBB and MySQL Docker containers"
sleep 1
docker-compose -f docker/docker-compose.yml down

echo "\nDeploying MyBB and MySQL to Docker Swarm"
sleep 1
docker swarm init
docker stack deploy --compose-file docker/docker-swarm.yml mybb

echo "\nInspecting MyBB and MySQL containers"
docker stack services mybb

echo "\nImporting data into MySQL"
# Wait for the MySQL container to come up (the lazy sleepy way)
sleep 45
mysql -h 127.0.0.1 -u root -pexample < database/mybb.sql

echo "\nTailing the logs..."
docker stack services -q mybb | xargs -L1 -I{} sh -c 'docker service logs -f {} &'

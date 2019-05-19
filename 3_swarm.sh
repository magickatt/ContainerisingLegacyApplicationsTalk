docker swarm init
docker stack deploy --compose-file docker-compose.yml mybb
docker stack services mybb
docker stack services -q mybb | xargs -L1 -I{} sh -c 'docker service logs -f {} &'

echo "Stopping Docker container from previous demonstration (if still running)"
docker stop $(docker ps -q --filter ancestor=localhost:5000/mybb:1_docker)

# Build the container locally, tag it then push it to a private repository
echo "\nBuilding MyBB Docker image"
sleep 1
docker build . -f docker/2_Dockerfile -t localhost:5000/mybb:2_compose
docker push localhost:5000/mybb:2_compose

#docker kill $(docker ps -q)
echo "\nRunning MyBB and MySQL Docker containers"
sleep 1
docker-compose -f docker/docker-compose.yml up -d

#export PATH=$PATH:/Applications/MySQL\ Workbench.app/Contents/MacOS
echo "\nImporting data into MySQL"
# Wait for the MySQL container to come up
dockerize --wait tcp://localhost:3306
mysql -h 127.0.0.1 -u root -pexample < database/mybb.sql

echo "\nTailing the logs..."
sleep 1
docker-compose -f docker/docker-compose.yml logs -f

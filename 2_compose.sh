# Build the container locally, tag it then push it to a private repository
echo "Building MyBB Docker image"
sleep 1
docker build . -f docker/2_Dockerfile -t magickatt/mybb:2_compose
docker push magickatt/mybb:2_compose

#docker kill $(docker ps -q)
echo "\nRunning MyBB and MySQL Docker containers"
sleep 1
docker-compose -f docker/docker-compose.yml up -d

#export PATH=$PATH:/Applications/MySQL\ Workbench.app/Contents/MacOS
echo "\nImporting data into MySQL"
# Wait for the MySQL container to come up (the lazy sleepy way)
sleep 15
mysql -h 127.0.0.1 -u root -pexample < database/mybb.sql

echo "\nTailing the logs..."
sleep 1
docker-compose -f docker/docker-compose.yml logs -f

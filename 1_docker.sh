# Remove the previously copied configuration from Step 0
rm -f application/inc/config.php application/inc/settings.php

# Build the container locally, tag it then push it to a private repository
echo "Building MyBB Docker image"
sleep 1
docker build . -f docker/1_Dockerfile -t magickatt/mybb:1_docker

echo "\nPushing MyBB Docker image to repository"
sleep 1
docker push magickatt/mybb:1_docker

# Run the container
echo "\nRunning MyBB Docker container"
docker run -p 80:80 -t magickatt/mybb:1_docker

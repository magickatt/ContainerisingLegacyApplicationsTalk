echo "Build and run a basic MyBB Docker container"

# Remove the previously copied configuration from Step 0
rm -f application/inc/config.php application/inc/settings.php

# Build the container locally, tag it then push it to a private repository
docker build . -f docker/1_Dockerfile -t localhost:5000/mybb:1_docker
docker push localhost:5000/mybb:1_docker

# Run the container
docker run -p 80:80 -t localhost:5000/mybb:1_docker

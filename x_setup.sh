# Initialise Helm
helm init --history-max 200

# Setup a local Docker registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

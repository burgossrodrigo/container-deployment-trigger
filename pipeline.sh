#!/bin/sh

# Define the directory where the repository is located
REPO_DIR="container-deployment-trigger"

# Define the Docker image name
IMAGE_NAME="container-deployment-trigger"

# Change to the directory containing the repository
cd $REPO_DIR

# Pull the latest changes from the repository
git pull

# Check if the Docker image exists
if [ "$(docker images -q $IMAGE_NAME)" ]; then
    echo "Image exists"

    # Check if the Docker container is running
    if [ "$(docker ps -q -f name=$IMAGE_NAME)" ]; then
        echo "Container is running, restarting it"

        # Restart the Docker container
        docker restart $IMAGE_NAME
    else
        echo "Container is not running, starting it"

        # Run the Docker container
        docker run -p 3000:3000 --name $IMAGE_NAME $IMAGE_NAME
    fi
else
    echo "Image does not exist, building it"

    # Build the Docker image
    docker build -t $IMAGE_NAME .

    # Run the Docker container
    docker run -p 3000:3000 --name $IMAGE_NAME $IMAGE_NAME
fi
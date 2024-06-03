#!/bin/bash

# Navigate to the repository directory
cd /home/admin/container-deployment-trigger || { echo "Directory not found"; exit 1; }

# Stash any local changes
git stash

# Pull the latest changes from the main branch
git pull origin main

# Apply the stashed changes (if any)
git stash pop

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
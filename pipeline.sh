#!/bin/sh

# Define the directory where the repository is located
REPO_DIR="container-deployment-trigger"

# Define the Docker image name
IMAGE_NAME="container-deployment-trigger"

# Change to the directory containing the repository
cd $REPO_DIR

# Pull the latest changes from the repository
git pull

# Build the Docker image
docker build -t $IMAGE_NAME .

# Run the Docker image
docker run -p 3000:3000 $IMAGE_NAME
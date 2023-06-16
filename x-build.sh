#!/bin/bash

# Hold instance state when the script starts
INSTANCE_UP=false

# detect if docker is installed
if ! [ -x "$(command -v docker)" ]; then
    echo "Docker is not installed. Please install docker and try again."
    exit 1
fi

# detect if docker-compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
    echo "Docker Compose is not installed. Please install docker-compose and try again."
    exit 1
fi

# detect if the network-multitool container is running
if [ "$(docker ps -q -f name=network-multitool)" ]; then
    # stop the compose
    INSTANCE_UP=true
fi

# if INSTANCE_UP is true, then stop the container
if [ "$INSTANCE_UP" = true ]; then
    # stop the compose
    docker compose down
fi

# Build the container (rebuilds if already built)
docker compose build

# if INSTANCE_UP is true, then start the container back up
if [ "$INSTANCE_UP" = true ]; then
    # start the compose
    docker compose up -d
fi
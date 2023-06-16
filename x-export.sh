#!/bin/bash

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

# Export the container to a tar file
docker save -o ./exported/network-multitool.docker ericwastaken/network-multitool
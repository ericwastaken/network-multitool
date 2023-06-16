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

# Load the container from an exported image
docker load -i ./exported/network-multitool.docker

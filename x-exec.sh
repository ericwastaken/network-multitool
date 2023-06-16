#!/bin/bash

# detect if the compose is running and start if not
if [ ! "$(docker ps -q -f name=network-multitool)" ]; then
    # start the compose
    docker compose up -d
fi

# Exec a command in the container (can receive pipe input)
docker exec -i network-multitool "$@"
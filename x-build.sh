#!/bin/bash

# Hold instance state when the script starts
INSTANCE_UP=false

# detect if the compose is running
if [ "$(docker ps -q -f name=network-multitool)" ]; then
    # stop the compose
    INSTANCE_UP=true
fi

# if INSTANCE_UP is true, then stop the compose
if [ "$INSTANCE_UP" = true ]; then
    # stop the compose
    docker compose down
fi

# Build the container (rebuilds if already built)
docker compose build

# if INSTANCE_UP is true, then start the compose
if [ "$INSTANCE_UP" = true ]; then
    # start the compose
    docker compose up -d
fi
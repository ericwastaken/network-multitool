#!/bin/bash

# detect if the compose is running and start if not
if [ ! "$(docker ps -q -f name=network-multitool)" ]; then
    # start the compose
    docker compose up -d
fi

# Shell into the running container (-t = interactive)
docker exec -it network-multitool /bin/bash
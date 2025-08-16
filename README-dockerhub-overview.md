# Network Multi-Tool (Enhanced)

A Docker image that bundles a broad set of networking and troubleshooting tools, plus convenient additions like 
Python 3, pip, jq, curl, and the Microsoft Azure CLI. It is based on the excellent wbitt/network-multitool image (via FORK)
with enhancements for day-to-day ops and scripting.

## Purpose

Use this container as a ready-to-run toolbox for:

- Network diagnostics and troubleshooting (curl, nc, dig, nslookup, traceroute, etc.)
- Scripting and automation with Python 3 and pip-installed packages
- Managing Azure resources with the Azure CLI (`az`)
- Keeping a lightweight container running with a built-in tiny web server (from the base image)
- See the full list of commands and tools at https://github.com/ericwastaken/Network-MultiTool-Base.

## Environment Variables

- `HTTP_PORT`: Port exposed by the built-in HTTP server (default often 80 in base image; example here uses 8080)
- `HTTPS_PORT`: Port exposed by the built-in HTTPS server (example uses 1443)

These control the small web server used to keep the container active. They can be left as-is for most use cases.

## Volumes

- Map a local folder to `/root/host-volume` to easily exchange files, scripts, and artifacts with the container.

Example: `-v $(pwd)/host-volume:/root/host-volume`

## Running with Docker CLI

Run the container using Docker (assumes you have a local `host-volume` folder for convenience):

```sh
docker run -d \
  --name network-multitool \
  --network host \
  -e HTTP_PORT=8080 \
  -e HTTPS_PORT=1443 \
  -v $(pwd)/host-volume:/root/host-volume \
  --restart unless-stopped \
  ericwastakenondocker/network-multitool:latest
```

Notes:
- Uses host networking so tools see the host's network directly.
- The small web server runs to keep the container alive when you’re not actively executing commands.

## Running with Docker Compose

Create a `compose.yml` (or use the example in the repository named `compose-using-dockerhub-image.yml`):

```yaml
services:
  network-multitool:
    image: ericwastakenondocker/network-multitool:latest
    container_name: network-multitool
    hostname: network-multitool
    restart: unless-stopped
    network_mode: "host"
    environment:
      - HTTP_PORT=8080
      - HTTPS_PORT=1443
    volumes:
      - ./host-volume:/root/host-volume
```

Start the service:

```sh
# For newer Docker versions
docker compose up -d

# For older Docker versions
docker-compose up -d
```

## Additional Commands

Stop the container:

```sh
docker compose down
# or
docker stop network-multitool && docker rm network-multitool
```

View logs (includes the tiny web server and any commands you run that write to stdout/stderr):

```sh
docker logs -f network-multitool
```

Open a shell in the running container:

```sh
docker exec -it network-multitool /bin/bash
```

Run a single command inside the container (examples):

```sh
# Retrieve your public IP
docker exec -i network-multitool curl https://ifconfig.co

# Use Azure CLI (after az login)
docker exec -it network-multitool az account show
```

## How It Works

This image extends `wbitt/network-multitool` and adds:

1. Python 3 and pip, so you can run Python scripts and install packages.
2. The Microsoft Azure CLI (`az`) installed in an isolated virtual environment and symlinked to the PATH.
3. Common utilities like `jq` and `curl` for JSON processing and HTTP tooling.
4. A mapped host volume at `/root/host-volume` so you can easily share files with the container.

The underlying multitool image includes a small HTTP/HTTPS server which keeps the container running continuously. You can then exec into the container to use the tools as needed.

## Usage Notes

- Requires Docker (and optionally Docker Compose) installed on your machine.
- Host networking is used for accurate network testing from the host’s perspective.
- Map `./host-volume` to `/root/host-volume` to edit scripts on your host and run them inside the container.
- Python packages can be pre-baked into the image by adding them to the build context (see the GitHub repo for details).

## GitHub

See the GitHub repo for more information, including helper scripts and examples:

https://github.com/ericwastaken/network-multitool

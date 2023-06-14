# NETWORK MULTI-TOOL

## Summary

A docker container with a set of tools for Linux. This is based on the Network-MultiTool container, but with a few tweaks added.

For all the commands packaged and full credit goes to: https://github.com/wbitt/Network-MultiTool

## Dependencies

* Docker must be installed on the host system.
* The host must have internet access to build the initial image. (See "Offline Usage" below if you need to use this in an offline environment.)

## Usage

### CONTAINER START
Start the container with the following command:

```bash
$ docker compose up -d
```
* Uses an NGINX web server to keep the container running.
* Network mode is HOST network, so the container will use the host's network stack and commands will have network host visibility. 
* On first "up" the image will build from the Dockerfile. This might take a few minutes. See below for "offline usage" if you need to use this in an offline environment.

### CONTAINER SHELL

After the container is running, get a shell with:

```bash
$ docker exec -it network-multitool /bin/bash
```
* You can also use the convenience script:
  ```bash
    $ ./x-shell.sh
  ```
* Note the host directory **./host-volume** is mapped into the container into **/root/host-volume**. This is a convenient way to move files between the host and the container.
* Exit the shell with CTRL-D or the exit command.

### CONTAINER STOP
To stop the container, use:

```bash
$ docker compose down
```

## Offline Usage

If you need to use this container on a server that does not have Internet, you can:
* Build the image on a connected server first.
  ```bash
  $ docker compose build
  ```
* Export the docker image to a file.
  ```bash
  $ ./x-export.sh
  ```
* Move the all the files in this repo, including the exported docker image, using any offline method (usb drive, etc.) The exported image is placed in the **./exported** directory if you use the convenience `x-export.sh` script.
* Load the image on the offline server.
  ```bash
  $ ./x-import.sh
  ```
* Start the container on the offline server as described above.



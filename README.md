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

### CONTAINER EXEC

With the container running, run any command with:

```bash
$ docker compose exec -it network-multitool <your-command> <args>'
```
* You can also use the convenience script `x-exec.sh your-command and any args`.

For example, to get the public IP of the host (using a CURL against https://ifconfig.co):
```bash
$ docker compose exec -it network-multitool curl https://ifconfig.co
```
or
```bash
$ ./x-exec.sh curl https://ifconfig.co
```

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

## Python Support

The container is enhanced with Python3, Pip3 and any packages defined in **host-volume/python-packages.txt**. This is useful for running python scripts in the container.

Scripts can be run from the host or from inside the container.

### Running Python Scripts from the Host

With the container running, run your script with:

```bash
$ docker compose exec -it network-multitool python <your-script>.py <args>'
```
* You can also use the convenience script `x-exec.sh your-python-script.py and any args`.

### Running Python Scripts from the Container

Once the container is running, enter the container. (See "CONTAINER SHELL" above.) Run your script with:
```bash
$ python <your-script>.py <args>'
```

## Customizations

This section discusses the customizations this repo makes to the original Network-MultiTool container.

1. Convenience scripts
   * `x-build.sh` - Builds the docker image.
   * `x-up.sh` - Starts the container.
   * `x-force-build-and-up.sh` - Forces a rebuild of the docker image and starts the container.
   * `x-exec.sh` - Runs a command inside the running container.
   * `x-shell.sh` - Starts a shell in the container.
   * `x-export.sh` - Exports the docker image to a file. Useful for moving the image to an offline server.
   * `x-import.sh` - Imports the docker image from a file. Useful for loading the image on an offline server.
2. Aliases inside the container:
   * `ll` (long list) mapped to `ls -al`
3. Maps the host directory **host-volume** into the container's **/root/host-volume** directory.
4. Support for python3, pip3 and any python dependencies listed in **host-volume/python-packages.txt**.





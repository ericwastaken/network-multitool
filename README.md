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
$ docker compose exec -i network-multitool <your-command> <args>'
```
* You can also use the convenience script `x-exec.sh your-command and any args`.

For example, to get the public IP of the host (using a CURL against https://ifconfig.co):
```bash
$ docker compose exec -i network-multitool curl https://ifconfig.co
```
or
```bash
$ ./x-exec.sh curl https://ifconfig.co
```

### CONTAINER EXEC WITH PATH ON HOST

This project provides a **bin-mapping** folder with a command that can be used to run commands inside the container. It's possible to add this folder to your PATH so that the tools could be used inside the HOST by replacing the tool name with `nmt <tool-name>`.

In your .basrc or .zshrc file add the following line to add the container's bin mapping to your path:

```bash
export PATH="/path/to/this/repo/bin-mapping:$PATH"
```

For example, with the above in place, you can run the following commands from the host:

```bash
# curl a remote site
$ nmt curl https://ifconfig.co
# netcat a host for a port
$ nmt nc -zv google.com 443
# Pass stdin to the container's jq command
$ cat /some/file/with/json | nmt jq
$ some-command-that-produces-json | nmt jq
```
(Note, these are only a few examples. ALL the commands in the container are available this way.)

### CONTAINER STOP
To stop the container, use:

```bash
$ docker compose down
```

## Offline Usage

If you need to use this container on a server that does not have Internet, you can:

* Add any Python packages you need to **host-volume/python-packages.txt**. See "Python Support" below.
* Build the image on a connected server first. From the root director of this repo:
  ```bash
  $ docker compose build
  ```
  * You can also use the convenience script `x-build.sh`.
* Export the docker image to a file. From the root directory of this repo:
  ```bash
  $ ./x-export.sh
  ```
* Move the all the files in this repo, including the exported docker image, using any offline method (usb drive, etc.) The exported image is placed in the **./exported** directory if you use the convenience `x-export.sh` script.
* Load the image on the offline server. On the offline server, from the root directory of this project:
  ```bash
  $ ./x-import.sh
  ```
* Start the container on the offline server as described above.

## Python Support

The container is enhanced with Python3, Pip3 and any packages defined in **host-volume/python-packages.txt**. This is useful for running python scripts in the container.

Scripts can be run from the host or from inside the container.

The pylogix package is installed by default along with some example scripts demonstrating how to communicate with Allen-Bradley PLCs.

> **Notes:** 
> 1. The pylogix package is not installed on the host. It is only installed in the container.
> 2. This project is not affiliated with Allen-Bradley or Rockwell Automation. The pylogix package is open source and available at: https://github.com/dmroeder/pylogix.

### Running Python Scripts from the Host

With the container running, run your script with:

```bash
$ docker compose exec -i network-multitool python <your-script>.py <args>'
```
* You can also use the convenience script `x-exec.sh your-python-script.py and any args`.
* Or if you've mapped the bin-mapping folder into your path, you can run:
  ```bash
  $ nmt python <your-script>.py <args>'
  ```

### Running Python Scripts from the Container

Once the container is running, enter the container. (See "CONTAINER SHELL" above.) Run your script with:
```bash
$ python <your-script>.py <args>'
```

### Adding Python Packages

Simply edit the file **host-volume/python-packages.txt** and add the package name and version to the file. The package will be installed the next time the container image is built. You might need to rebuild with `docker compose build` or with the convenience script `./x-build.sh`.

## Customizations

This section discusses the customizations this repo makes to the original Network-MultiTool container.

1. Convenience scripts, which verify dependencies and run docker commands when necessary:
   * `x-build.sh` - Builds the docker image.
   * `x-up.sh` - Starts the container.
   * `x-force-build-and-up.sh` - Forces a rebuild of the docker image and starts the container.
   * `x-exec.sh` - Runs a command inside the running container.
   * `x-shell.sh` - Starts a shell in the container.
   * `x-export.sh` - Exports the docker image to a file. Useful for moving the image to an offline server.
   * `x-import.sh` - Imports the docker image from a file. Useful for loading the image on an offline server.
2. Support for running the container commands via the host's PATH.
3. Aliases inside the container:
   * `ll` (long list) mapped to `ls -al`
4. Maps the host directory **host-volume** into the container's **/root/host-volume** directory.
5. Support for python3, pip3 and any python dependencies listed in **host-volume/python-packages.txt**. Some example python scripts are also included.





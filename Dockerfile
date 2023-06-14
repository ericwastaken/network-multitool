FROM wbitt/network-multitool as base

# Set Prompt
ENV PS1="\u@\h:\w$ "
# Add alias to user profile
RUN echo "alias ll='ls -la'" >> /root/.bashrc

# Frpom https://stackoverflow.com/questions/62554991/how-do-i-install-python-on-alpine-linux
# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
COPY ./host-volume/python-packages.txt /root/host-volume/python-packages.txt
RUN pip install -r /root/host-volume/python-packages.txt
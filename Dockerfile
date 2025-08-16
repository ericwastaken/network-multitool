FROM wbitt/network-multitool AS base

# Shell niceties
ENV PS1="\u@\h:\w$ "
RUN echo "alias ll='ls -la'" >> /root/.bashrc

# Python + pip
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache python3 py3-pip bash curl jq \
 && ln -sf python3 /usr/bin/python \
 && python3 -m ensurepip \
 && pip3 install --no-cache --upgrade pip setuptools wheel

# Build toolchain (kept until we finish installing BOTH azure-cli and your app deps)
RUN apk add --no-cache --virtual .build-deps \
      gcc musl-dev python3-dev libffi-dev openssl-dev cargo make

# --- Azure CLI in isolated venv ---
ARG AZ_CLI_VERSION=2.76.0
RUN python3 -m venv /opt/az \
 && /opt/az/bin/pip install --upgrade pip \
 && /opt/az/bin/pip install --no-cache-dir "azure-cli==${AZ_CLI_VERSION}" \
 && ln -s /opt/az/bin/az /usr/local/bin/az

# Your Python deps (system interpreter, separate from /opt/az)
COPY host-volume/requirements.txt /root/host-volume/requirements.txt
RUN pip3 install --no-cache-dir -r /root/host-volume/requirements.txt

# Now we can safely drop build deps if nothing else needs them
RUN apk del .build-deps

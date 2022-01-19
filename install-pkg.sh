#!/bin/bash
set -ex

# Install pkgs
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release iputils-ping
apt-get install -y vim dnsutils direnv tmux
apt-get install -y nodejs bison golang redis-tools mariadb-client

# Install Docker
curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce-cli

# Install Docker Compose
export LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")')
curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install promu
cd /tmp
wget -q https://github.com/prometheus/promu/releases/download/v0.13.0/promu-0.13.0.linux-amd64.tar.gz
tar -xf promu-0.13.0.linux-amd64.tar.gz
mv promu-0.13.0.linux-amd64/promu /usr/local/bin/promu

# Clean up
apt-get -y autoremove
apt-get -y clean
rm -rf /var/lib/apt/lists/*
rm -rf /var/log/*
rm -rf /tmp/*

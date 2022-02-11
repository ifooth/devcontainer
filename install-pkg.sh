#!/bin/bash
set -ex

# Install pkgs
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release iputils-ping dnsutils
apt-get install -y vim direnv tmux openssh-server

# system language
apt-get install -y nodejs bison golang

# component client
apt-get install -y redis-tools mariadb-client etcd-client

# zsh utils 命令行终端
apt-get install -y autojump fzf
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /usr/local/bin/zsh-install.sh && chmod a+x /usr/local/bin/zsh-install.sh
export ZSH="/opt/oh-my-zsh" && export CHSH=no && zsh-install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH}/custom/plugins/zsh-autosuggestions

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

# Install adb
wget -q https://dl.google.com/android/repository/platform-tools_r31.0.3-linux.zip
unzip platform-tools_r31.0.3-linux.zip
mv platform-tools /usr/local/android-platform-tools
ln -sf /usr/local/android-platform-tools/adb /usr/local/bin

# Clean up
apt-get -y autoremove
apt-get -y clean
rm -rf /var/lib/apt/lists/*

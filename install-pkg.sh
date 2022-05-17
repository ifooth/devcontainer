#!/bin/bash
set -ex

# Install pkgs
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release iputils-ping dnsutils lrzsz
apt-get install -y vim direnv tmux cloc

# Install kernel build tools
apt-get install -y flex bc libelf-dev libssl-dev

# system language
apt-get install -y bison golang

# client utils
apt-get install -y redis-tools mariadb-client etcd-client

# sshd
apt-get install -y openssh-server
echo "AcceptEnv SHELL_OS LC_*" > /etc/ssh/sshd_config.d/devcontainer.conf

# zsh utils 命令行终端
apt-get install -y autojump fzf
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /usr/local/bin/zsh-install.sh && chmod a+x /usr/local/bin/zsh-install.sh
export ZSH="/opt/oh-my-zsh" && export CHSH=no && zsh-install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH}/custom/plugins/zsh-autosuggestions

# Vim
git clone https://github.com/VundleVim/Vundle.vim.git /opt/vim/bundle/Vundle.vim
cd /opt/vim/bundle
grep Plugin /opt/root/.vimrc.bundles|grep -v '"'|grep -v "Vundle"|awk -F "'" '{print $2}'|xargs -L1 git clone

# vscode python tools & utils
pip install virtualenvwrapper supervisor flake8 black isort s3cmd mycli ipython ipdb requests

# RUN echo "dash dash/sh boolean false" | debconf-set-selections
# RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Install Docker
curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce-cli

# Install Docker Compose
export LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")')
curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install NodeJS
cd /tmp
NODEJS_VERSION=v16.14.0
wget -q https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz
tar -xf node-${NODEJS_VERSION}-linux-x64.tar.xz
mv node-${NODEJS_VERSION}-linux-x64 /opt/node
ln -sf /opt/node/bin/node /usr/local/bin/
ln -sf /opt/node/bin/npm /usr/local/bin/
# 全局配置
echo "prefix=/root/.npm-packages" > /opt/node/lib/node_modules/npm/npmrc

# Install promu
cd /tmp
PROMU_VERSION=0.13.0
wget -q https://github.com/prometheus/promu/releases/download/v${PROMU_VERSION}/promu-${PROMU_VERSION}.linux-amd64.tar.gz
tar -xf promu-${PROMU_VERSION}.linux-amd64.tar.gz
mv promu-${PROMU_VERSION}.linux-amd64/promu /usr/local/bin/promu

RESTIC_VERSION=0.12.1
wget -q https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2
bunzip2 restic_${RESTIC_VERSION}_linux_amd64.bz2
chmod a+x restic_${RESTIC_VERSION}_linux_amd64 && mv restic_${RESTIC_VERSION}_linux_amd64 /usr/local/bin/restic

RCLONE_VERSION=v1.57.0
wget -q https://github.com/rclone/rclone/releases/download/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-amd64.deb
dpkg -i rclone-${RCLONE_VERSION}-linux-amd64.deb

# Install adb
ADB_TOOLS_VERSION=r31.0.3
wget -q https://dl.google.com/android/repository/platform-tools_${ADB_TOOLS_VERSION}-linux.zip
unzip platform-tools_${ADB_TOOLS_VERSION}-linux.zip
mv platform-tools /opt/android-platform-tools
ln -sf /opt/android-platform-tools/adb /usr/local/bin

# Install Helm
HELM_VERSION=v3.8.1
wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
tar -xf helm-${HELM_VERSION}-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/

# Install Kubectl
KUBECTL_VERSION=v1.20.15
wget -q https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
chmod a+x kubectl && mv kubectl /usr/local/bin/

# Clean up
mkdir -p /data/repos /data/logs /data/etc/supervisord

apt-get -y autoremove
apt-get -y clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

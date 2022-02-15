#!/bin/bash
set -ex

# Install pkgs
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release iputils-ping dnsutils
apt-get install -y vim direnv tmux cloc

# system language
apt-get install -y nodejs bison golang

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

# vscode golang tools
export GO111MODULE=on
export GOPATH=/opt/go
go get github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go get github.com/ramya-rao-a/go-outline@latest
go get github.com/cweill/gotests/gotests@latest
go get github.com/fatih/gomodifytags@latest
go get github.com/josharian/impl@latest
go get github.com/haya14busa/goplay/cmd/goplay@latest
go get github.com/go-delve/delve/cmd/dlv@latest
go get honnef.co/go/tools/cmd/staticcheck@latest
go get golang.org/x/tools/gopls@latest
# clean cache
rm -rf /opt/go/pkg

# vscode python tools & utils
pip install virtualenvwrapper supervisor flake8 black isort s3cmd mycli ipython ipdb

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
mv platform-tools /usr/local/android-platform-tools
ln -sf /usr/local/android-platform-tools/adb /usr/local/bin

# Clean up
mkdir -p /data/repos /data/logs

apt-get -y autoremove
apt-get -y clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

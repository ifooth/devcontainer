#!/bin/bash
mkdir -p /data/repos
mkdir -p /data/logs

# start sshd
mkdir -p /run/sshd
SSHD_PORT=${SSHD_PORT:-36022}
SSHD_PORT_LINE=$(awk '/Port/{ print NR; exit }' /etc/ssh/sshd_config)
sed -i "${SSHD_PORT_LINE}c Port ${SSHD_PORT}" /etc/ssh/sshd_config

# set vscode settings
mkdir -p ~/.vscode-server/data/Machine
cp -rf /etc/vscode-settings/remote-ssh.json ~/.vscode-server/data/Machine/settings.json

# 覆盖固定配置文件 .zshrc .bashrc .profile
echo "set root profile"
tar -xvf /root.tar.gz -C /

if [ -f "/usr/local/bin/dev-init.sh" ];then
    echo "dev init"
    /usr/local/bin/dev-init.sh
fi

/usr/local/bin/supervisord -c /etc/supervisord.conf -n

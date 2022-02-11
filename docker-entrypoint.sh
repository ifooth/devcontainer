#!/bin/bash
mkdir -p /data/repos
mkdir -p /data/logs

# start sshd
mkdir -p /run/sshd
SSHD_PORT=${SSHD_PORT:-36022}
echo "Port $SSHD_PORT" >> /etc/ssh/sshd_config

# 覆盖固定配置文件 .zshrc .bashrc .profile
tar -xvf /root.tar.gz -C /

if [ -f "/usr/local/bin/dev-init.sh" ];then
    echo "dev init"
    /usr/local/bin/dev-init.sh
fi

/usr/local/bin/supervisord -c /etc/supervisord.conf -n

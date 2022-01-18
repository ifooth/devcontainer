#!/bin/bash
mkdir -p /data/repos
mkdir -p /data/logs

if [ ! -d "/root/.pyenv" ];then
    echo "no root data, extract root.tar.gz"
    tar -xf /root.tar.gz -C /
else
    echo "root data already extract"
fi

if [ -f "/usr/local/bin/dev-init.sh" ];then
    echo "dev init"
    /usr/local/bin/dev-init.sh
fi

/usr/local/bin/supervisord -c /etc/supervisord.conf -n

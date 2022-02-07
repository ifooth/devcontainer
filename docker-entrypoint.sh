#!/bin/bash
mkdir -p /data/repos
mkdir -p /data/logs

# start sshd
mkdir -p /run/sshd
SSHD_PORT=${SSHD_PORT:-36022}
echo "Port $SSHD_PORT" >> /etc/ssh/sshd_config
# Fix: lastlog_openseek: Couldn't stat /var/log/lastlog: No such file or directory
touch /var/log/lastlog

# if [ ! -d "/root/.pyenv" ];then
#     echo "no root data, extract root.tar.gz"
#     tar -xf /root.tar.gz -C /
# else
#     echo "root data already extract"
# fi

if [ -f "/usr/local/bin/dev-init.sh" ];then
    echo "dev init"
    /usr/local/bin/dev-init.sh
fi

/usr/local/bin/supervisord -c /etc/supervisord.conf -n

#!/usr/bin/zsh
source /opt/root/.zshrc

export JUPYTER_PORT=${JUPYTER_PORT:-8088}
export JUPYTER_TOKEN=${JUPYTER_TOKEN:-devcontainer}
export JUPYTER_NOTEBOOK_DIR=${JUPYTER_NOTEBOOK_DIR:-/data/repos/jupyter-notebook}

if [ -n "$PRE_SCRIPT_FILE" ];then
    echo "run pre_script $PRE_SCRIPT_FILE"
    bash $PRE_SCRIPT_FILE
fi

mkdir -p /data/repos /data/pub /data/logs $JUPYTER_NOTEBOOK_DIR

# start sshd
mkdir -p /run/sshd
SSHD_PORT=${SSHD_PORT:-36022}
echo "Port $SSHD_PORT" > /etc/ssh/sshd_config.d/port.conf

# keep ssh host
SSHD_CONF_DIR="${HOME}/.sshd"
if [ ! -d "$SSHD_CONF_DIR" ];then
    echo "reset ssh host key"
    rm -rf /etc/ssh/ssh_host_*
    dpkg-reconfigure openssh-server
    mkdir -p $SSHD_CONF_DIR
    cp -rf /etc/ssh/ssh_host_* $SSHD_CONF_DIR
else
    echo "copy ssh host key"
    cp -rf $SSHD_CONF_DIR/* /etc/ssh/
fi

# 覆盖固定配置文件 .zshrc .bashrc .profile
echo "set root profile"
tar -xvf /root.tar.gz -C /

echo "run dev init"
/usr/local/bin/dev-init.sh

if [ -n "$POST_SCRIPT_FILE" ];then
    echo "run post_script $POST_SCRIPT_FILE"
    bash $POST_SCRIPT_FILE
fi

/usr/bin/supervisord -c /etc/supervisord.conf -n

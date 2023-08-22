#!/usr/bin/zsh
source /opt/root/.zshrc

if [ -n $PRE_SCRIPT_FILE ]
    echo "run pre_script $PRE_SCRIPT_FILE"
    bash $PRE_SCRIPT_FILE
fi

mkdir -p /data/repos /data/logs

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

# set vscode settings
mkdir -p ~/.vscode-server/data/Machine
cp -rf /opt/vscode/settings/remote-ssh.json ~/.vscode-server/data/Machine/settings.json

# 覆盖固定配置文件 .zshrc .bashrc .profile
echo "set root profile"
tar -xvf /root.tar.gz -C /

echo "run dev init"
/usr/local/bin/dev-init.sh

if [ -n $POST_SCRIPT_FILE ]
    echo "run pre_script $POST_SCRIPT_FILE"
    bash $POST_SCRIPT_FILE
fi

/usr/local/bin/supervisord -c /etc/supervisord.conf -n

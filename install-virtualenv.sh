#!/bin/bash
set -ex

# gvm golang 多版本环境
export GVM_ROOT=/opt/gvm
curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /usr/local/bin/gvm-installer
chmod a+x /usr/local/bin/gvm-installer && gvm-installer master /opt
source "/opt/gvm/scripts/gvm"
# change go version if upgrade
export GO1_15=go1.15.15
export GO1_17=go1.17.9
export GO1_18=go1.18.1

gvm install $GO1_15 -B
gvm install $GO1_17 -B
gvm install $GO1_18 -B

# 软链大版本 方便升级
cd /opt/gvm/gos
ln -sf $GO1_15 go1.15
ln -sf $GO1_17 go1.17
ln -sf $GO1_18 go1.18

cd /opt/gvm/environments
ln -sf $GO1_15 go1.15
ln -sf $GO1_17 go1.17
ln -sf $GO1_18 go1.18

cd /opt/gvm/pkgsets
mv $GO1_15 go1.15 && ln -sf go1.15 $GO1_15
mv $GO1_17 go1.17 && ln -sf go1.17 $GO1_17
mv $GO1_18 go1.18 && ln -sf go1.18 $GO1_18

cd /opt/gvm && tar -zcf pkgsets.tar.gz pkgsets

# vscode golang tools, build with latest golang
# https://github.com/golang/vscode-go/blob/master/docs/tools.md
gvm use $GO1_18
export GOPATH=/opt/go
go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
go install github.com/haya14busa/goplay/cmd/goplay@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install golang.org/x/tools/gopls@latest

# golang小工具
go install github.com/ungerik/pkgreflect@latest
# clean cache
rm -rf /opt/go/pkg

# pyenv python 多版本环境
export PYENV_ROOT=/opt/pyenv
curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
export PATH=${PYENV_ROOT}/bin:$PATH
# change python version if upgrade
export PY2_7=2.7.18
export PY3_6=3.6.15
export PY3_10=3.10.4

pyenv install $PY2_7
pyenv install $PY3_6
pyenv install $PY3_10

# 软链大版本 方便升级
cd /opt/pyenv/versions
ln -sf $PY2_7 2.7
ln -sf $PY3_6 3.6
ln -sf $PY3_10 3.10

cd /opt/pyenv && tar -zcf versions.tar.gz versions/3.10/lib/python3.10/site-packages

# 添加环境变量
cat <<\EOT >> /root/.bashrc
# add go and python path
export PATH=/data/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:/root/.npm-packages/bin:$PATH

# ssh and vscode terminal use zsh
if [[ -n "${SSH_TTY}" ]] || [[ -n "${VSCODE_GIT_IPC_HANDLE}" ]];then
    exec zsh
fi
EOT

# Clean up & Package root dir
rm -rf /opt/gvm/archive/*.tar.gz
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

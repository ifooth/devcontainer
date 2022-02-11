#!/bin/bash
set -ex

# golang 环境

# vscode 依赖
export GO111MODULE=on
export GOPATH=/opt/go
go get github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go get github.com/ramya-rao-a/go-outline@latest
go get github.com/cweill/gotests/gotests@latest
go get github.com/fatih/gomodifytags@latest
go get github.com/josharian/impl@latest
go get github.com/haya14busa/goplay/cmd/goplay@latest
go get github.com/go-delve/delve/cmd/dlv@latest
GOBIN=/tmp/ go get github.com/go-delve/delve/cmd/dlv@2f13672765fe && mv /tmp/dlv /opt/go/bin/dlv-dap
go get honnef.co/go/tools/cmd/staticcheck@latest
go get golang.org/x/tools/gopls@latest

# gvm
export GVM_ROOT=/opt/gvm
curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /usr/local/bin/gvm-installer
chmod a+x /usr/local/bin/gvm-installer && gvm-installer master /opt
source "/opt/gvm/scripts/gvm"
gvm install go1.15.15 -B
gvm install go1.17.6 -B
cd /opt/gvm && tar -zcf pkgsets.tar.gz pkgsets

# python 环境
pip install virtualenvwrapper supervisor flake8 black isort

export PYENV_ROOT=/opt/pyenv
git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
export PATH=/data/bin:${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:$PATH
pyenv install 2.7.18
pyenv install 3.6.15
pyenv install 3.10.1

# 添加环境变量
echo 'export PYENV_ROOT=/opt/pyenv' >> /root/.bashrc
echo 'export GVM_ROOT=/opt/gvm' >> /root/.bashrc
echo 'export PATH=/data/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:$PATH' >> /root/.bashrc
echo 'exec zsh' >> /root/.bashrc

# ssh fabric
mkdir -p /root/.ssh
touch /root/.ssh/config

# 打包整个root, 减少大小和复用
rm -rf /tmp/*
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

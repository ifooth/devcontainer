#!/bin/bash
set -ex

# gvm golang 多版本环境
export GVM_ROOT=/opt/gvm
curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /usr/local/bin/gvm-installer
chmod a+x /usr/local/bin/gvm-installer && gvm-installer master /opt
source "/opt/gvm/scripts/gvm"
gvm install go1.15.15 -B
gvm install go1.17.7 -B

# 软链大版本 方便升级
cd /opt/gvm/gos
ln -sf go1.15.15 go1.15
ln -sf go1.17.7 go1.17

cd /opt/gvm/pkgsets
mv go1.15.15 go1.15 && ln -sf go1.15 go1.15.15
mv go1.17.7 go1.17 && ln -sf go1.17 go1.17.7

cd /opt/gvm && tar -zcf pkgsets.tar.gz pkgsets

# pyenv python 多版本环境
export PYENV_ROOT=/opt/pyenv
git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
export PATH=${PYENV_ROOT}/bin:$PATH
pyenv install 2.7.18
pyenv install 3.6.15
pyenv install 3.10.2

# 软链 大版本 方便升级
cd /opt/pyenv/versions
ln -sf 2.7.18 2.7
ln -sf 3.6.15 3.6
ln -sf 3.10.2 3.10

cd /opt/pyenv && tar -zcf versions.tar.gz versions/3.10/lib/python3.10/site-packages

# 添加环境变量
echo 'export PATH=/data/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:$PATH' >> /root/.bashrc
echo 'exec zsh' >> /root/.bashrc

# Clean up & Package root dir
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

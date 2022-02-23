#!/bin/bash
set -ex

# gvm golang 多版本环境
export GVM_ROOT=/opt/gvm
curl -fsSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer -o /usr/local/bin/gvm-installer
chmod a+x /usr/local/bin/gvm-installer && gvm-installer master /opt
source "/opt/gvm/scripts/gvm"
# change go version if upgrade
export GO1_15=go1.5.15
export GO1_17=go1.17.7

gvm install $GO1_15 -B
gvm install $GO1_17 -B

# 软链大版本 方便升级
cd /opt/gvm/gos
ln -sf $GO1_15 go1.15
ln -sf $GO1_17 go1.17

cd /opt/gvm/environments
ln -sf $GO1_15 go1.15
ln -sf $GO1_17 go1.17

cd /opt/gvm/pkgsets
mv $GO1_15 go1.15 && ln -sf go1.15 $GO1_15
mv $GO1_17 go1.17 && ln -sf go1.17 $GO1_17

cd /opt/gvm && tar -zcf pkgsets.tar.gz pkgsets

# pyenv python 多版本环境
export PYENV_ROOT=/opt/pyenv
git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
export PATH=${PYENV_ROOT}/bin:$PATH
# change python version if upgrade
export PY2_7=2.7.18
export PY3_6=3.6.15
export PY3_10=3.10.2

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
echo 'export PATH=/data/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:$PATH' >> /root/.bashrc
echo 'exec zsh' >> /root/.bashrc

# Clean up & Package root dir
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

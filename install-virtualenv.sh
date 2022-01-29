#!/bin/bash
set -ex

# golang 环境

# vscode 依赖
export GO111MODULE=on
go get github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go get github.com/ramya-rao-a/go-outline@latest
go get github.com/cweill/gotests/gotests@latest
go get github.com/fatih/gomodifytags@latest
go get github.com/josharian/impl@latest
go get github.com/haya14busa/goplay/cmd/goplay@latest
go get github.com/go-delve/delve/cmd/dlv@latest
GOBIN=/tmp/ go get github.com/go-delve/delve/cmd/dlv@2f13672765fe && mv /tmp/dlv /root/go/bin/dlv-dap
go get honnef.co/go/tools/cmd/staticcheck@latest
go get golang.org/x/tools/gopls@latest

# gvm
bash< <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source "/root/.gvm/scripts/gvm"
gvm install go1.15.15 -B
gvm install go1.17.6 -B

# python 环境
pip install virtualenvwrapper supervisor flake8 black isort

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
export PATH=/data/bin:/root/.pyenv/bin:/root/.pyenv/shims:$PATH
pyenv install 2.7.18
pyenv install 3.6.15
pyenv install 3.10.1

# 添加环境变量
echo 'export PATH=/data/bin:/root/go/bin:/root/.pyenv/bin:/root/.pyenv/shims:$PATH' >> /root/.bashrc
echo 'exec zsh' >> /root/.bashrc

# 解决 docker 内 zsh 不能自动补全问题
echo 'autoload -Uz compinit' >> /root/.zshrc
echo 'compinit' >> /root/.zshrc
echo 'source ~/.zsh_profile' >> /root/.zshrc

# ssh fabric
mkdir -p /root/.ssh
touch /root/.ssh/config

# 打包整个root, 减少大小和复用
# cd / && tar -zcf root.tar.gz root && rm -rf root

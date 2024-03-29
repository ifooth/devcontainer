#!/bin/bash
set -ex

# golang 多版本环境
export GOPATH=/opt/go
export CGO_ENABLED=0
# change go version if upgrade
export GO1_15=go1.15.15
export GO1_20=go1.20.14 # 当前版本
export GO1_22=go1.22.0

go install golang.org/dl/$GO1_15@latest
go install golang.org/dl/$GO1_20@latest
go install golang.org/dl/$GO1_22@latest

export HOME=/opt/go
$GOPATH/bin/$GO1_15 download && rm -rf $GOPATH/sdk/$GO1_15/$GO1_15.linux-amd64.tar.gz
$GOPATH/bin/$GO1_20 download && rm -rf $GOPATH/sdk/$GO1_20/$GO1_20.linux-amd64.tar.gz
$GOPATH/bin/$GO1_22 download && rm -rf $GOPATH/sdk/$GO1_22/$GO1_22.linux-amd64.tar.gz

# 清理下载器
rm -rf $GOPATH/bin/$GO1_15
rm -rf $GOPATH/bin/$GO1_20
rm -rf $GOPATH/bin/$GO1_22

# 软链大版本 方便升级
cd /opt/go/bin
ln -sf /opt/go/sdk/$GO1_15/bin/go go1.15
ln -sf /opt/go/sdk/$GO1_20/bin/go go1.20
ln -sf /opt/go/sdk/$GO1_22/bin/go go1.22
ln -sf /opt/go/sdk/$GO1_22/bin/go go

cd /opt/go/sdk
ln -sf $GO1_15 go1.15
ln -sf $GO1_20 go1.20
ln -sf $GO1_22 go1.22
ln -sf $GO1_22 go

# vscode golang tools, build with latest golang
# https://github.com/golang/vscode-go/blob/master/docs/tools.md
export PATH=$GOPATH/bin:$PATH
# vscode dev
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
go install github.com/haya14busa/goplay/cmd/goplay@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.55.1
# https://github.com/golang/tools
go install golang.org/x/tools/gopls@latest

# protobuf
# https://github.com/protocolbuffers/protobuf-go
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31.0
# https://github.com/grpc/grpc-go
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.16.2
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.16.2

# golang小工具
go install golang.org/x/tools/cmd/stringer@latest

# my dev
go install github.com/ifooth/devcontainer/cmd/dev@latest

# clean cache
rm -rf /opt/go/pkg
rm -rf /opt/go/.cache

# pyenv python 多版本环境
export PYENV_ROOT=/opt/pyenv
curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ${PYENV_ROOT}/plugins/pyenv-virtualenvwrapper
export PATH=${PYENV_ROOT}/bin:$PATH
# change python version if upgrade
export PY2_7=2.7.18
export PY3_6=3.6.15
export PY3_10=3.10.11

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
export PATH=/data/bin:/root/.go/bin:/opt/go/bin:/opt/pyenv/bin:/opt/pyenv/shims:/root/.npm-packages/bin:$PATH

# ssh and vscode terminal use zsh
if [[ -n "${SSH_TTY}" ]] || [[ -n "${VSCODE_GIT_IPC_HANDLE}" ]];then
    exec zsh
fi
EOT

# Clean up & Package root dir
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

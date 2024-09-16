#!/bin/bash
set -ex

# golang 多版本环境
export GOPATH=/opt/go
export CGO_ENABLED=0
# change go version if upgrade
export GO1_20=go1.20.14 # 当前版本
export GO1_23=go1.23.1

go install golang.org/dl/$GO1_20@latest
go install golang.org/dl/$GO1_23@latest

export HOME=/opt/go
$GOPATH/bin/$GO1_20 download && rm -rf $GOPATH/sdk/$GO1_20/$GO1_20.linux-amd64.tar.gz
$GOPATH/bin/$GO1_23 download && rm -rf $GOPATH/sdk/$GO1_23/$GO1_23.linux-amd64.tar.gz

# 清理下载器
rm -rf $GOPATH/bin/$GO1_20
rm -rf $GOPATH/bin/$GO1_23

# 软链大版本 方便升级
cd /opt/go/bin
ln -sf /opt/go/sdk/$GO1_20/bin/go go1.20
ln -sf /opt/go/sdk/$GO1_23/bin/go go1.23
ln -sf /opt/go/sdk/$GO1_23/bin/go go

cd /opt/go/sdk
ln -sf $GO1_20 go1.20
ln -sf $GO1_23 go1.23
ln -sf $GO1_23 go

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
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.60.3
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
export UV_PYTHON_INSTALL_DIR=/opt/python/versions
export UV_LINK_MODE=copy
export UV_NO_CACHE="1"

# change python version if upgrade
export PY3_12=3.12.5

uv python install $PY3_12

# 硬链接大版本 方便升级
cd /opt/python
cp -lr /opt/python/versions/cpython-${PY3_12}-linux-x86_64-gnu py${PY3_12}
cp -lr py${PY3_12} py3.12
cp -lr py${PY3_12} py3

uv venv notebook -p /opt/python/py3.12/bin/python
source ./notebook/bin/activate
# vscode python tools, notebook & utils
uv pip install pip ruff ipython ipdb jupyterlab jupyterlab-lsp matplotlib sympy arrow openpyxl pandas requests

# 添加环境变量等
echo "" >> /root/.bashrc
cat /opt/root/.bashrc_append.sh >> /root/.bashrc

# Clean up & Package root dir
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

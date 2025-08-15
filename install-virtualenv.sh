#!/bin/bash
set -ex

# golang 多版本环境
export GOPATH=/opt/go
export CGO_ENABLED=0
# change go version if upgrade
export GO1_23=go1.23.10
export GO1_25=go1.25.0

go install golang.org/dl/$GO1_23@latest
go install golang.org/dl/$GO1_25@latest

export HOME=/opt/go
$GOPATH/bin/$GO1_23 download && rm -rf $GOPATH/sdk/$GO1_23/$GO1_23.linux-amd64.tar.gz
$GOPATH/bin/$GO1_25 download && rm -rf $GOPATH/sdk/$GO1_25/$GO1_25.linux-amd64.tar.gz

# 清理下载器
rm -rf $GOPATH/bin/$GO1_23
rm -rf $GOPATH/bin/$GO1_25

# 软链大版本 方便升级
cd /opt/go/bin
ln -sf /opt/go/sdk/$GO1_23/bin/go go1.23
ln -sf /opt/go/sdk/$GO1_25/bin/go go1.25
ln -sf /opt/go/sdk/$GO1_23/bin/go go

cd /opt/go/sdk
ln -sf $GO1_23 go1.23
ln -sf $GO1_25 go1.25
ln -sf $GO1_23 go

# vscode golang tools, build with latest golang
# https://github.com/golang/vscode-go/blob/master/docs/tools.md
export PATH=$GOPATH/bin:$PATH

# cd hack/tools && go1.25 install tool

# vscode dev
go1.25 install golang.org/x/tools/gopls@latest
go1.25 install github.com/go-delve/delve/cmd/dlv@latest
go1.25 install github.com/golang/vscode-go/vscgo@latest
go1.25 install github.com/haya14busa/goplay/cmd/goplay@latest
go1.25 install github.com/fatih/gomodifytags@latest
go1.25 install github.com/josharian/impl@latest
go1.25 install github.com/cweill/gotests/gotests@latest
go1.25 install github.com/golangci/golangci-lint/cmd/golangci-lint@v2.4.0

# protobuf
# https://github.com/protocolbuffers/protobuf-go
go1.25 install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31.0
# https://github.com/grpc/grpc-go
go1.25 install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
go1.25 install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.16.2
go1.25 install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.16.2

# my dev
go1.25 install golang.org/x/perf/cmd/benchstat@latest
go1.25 install github.com/ifooth/devcontainer/cmd/dev@v0.0.1
go1.25 install github.com/ifooth/devcontainer/cmd/gen-lint@v0.0.1

# clean cache
rm -rf /opt/go/pkg
rm -rf /opt/go/.cache

# pyenv python 多版本环境
export UV_PYTHON_INSTALL_DIR=/opt/python/versions
export UV_LINK_MODE=copy
export UV_NO_CACHE="1"

# change python version if upgrade
export PY3_12=3.12.11

uv python install $PY3_12

# 硬链接大版本 方便升级
cd /opt/python
cp -lr /opt/python/versions/cpython-${PY3_12}-linux-x86_64-gnu py${PY3_12}
cp -lr py${PY3_12} py3.12
cp -lr py${PY3_12} py3

uv venv notebook -p /opt/python/py3.12/bin/python
source ./notebook/bin/activate

# vscode python tools, notebook & utils
uv pip install pip ruff ipython ipdb arrow openpyxl pandas requests \
    jupyterlab jupyterlab-lsp jupyterlab-widgets jupyterlab-git jupyterlab_code_formatter python-lsp-ruff matplotlib sympy

# 添加环境变量等
echo "" >> /root/.bashrc
cat /opt/root/.bashrc_append.sh >> /root/.bashrc

# Clean up & Package root dir
rm -rf /tmp/*

rsync -avz /opt/root/ /root
cd /root && rm -rf .oh-my-zsh .wget-hsts .python_history .cache .zshrc.pre-oh-my-zsh && ls -la /root
cd / && tar -zcf root.tar.gz root

#!/bin/bash
set -ex

# openspec
echo "prefix=/opt/npm" > /opt/node/lib/node_modules/npm/npmrc
npm install -g @fission-ai/openspec@latest

# cursor cli
export HOME=/opt/cursor
curl https://cursor.com/install -fsS | bash

mkdir -p /opt/bin
cp -rf /opt/cursor/.local/bin/agent /opt/npm/bin
cp -rf /opt/cursor/.local/bin/cursor-agent /opt/npm/bin

# 全局配置
echo "prefix=/root/.npm-packages" > /opt/node/lib/node_modules/npm/npmrc

# 可使用 vscode / cursor 快捷打开项目目录,
# 注: code 会按当前所属编辑器打开
ln -sf /opt/scripts/open-editor.sh /opt/bin/vscode
ln -sf /opt/scripts/open-editor.sh /opt/bin/cursor

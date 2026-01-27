#!/bin/bash
set -ex

# openspec
npm install -g @fission-ai/openspec@latest

# cursor cli
export HOME=/opt/cursor
curl https://cursor.com/install -fsS | bash

mkdir -p /opt/bin
cp -rf /opt/cursor/.local/bin/agent /opt/bin
cp -rf /opt/cursor/.local/bin/cursor-agent /opt/bin

# 全局配置
echo "prefix=/root/.npm-packages" > /opt/node/lib/node_modules/npm/npmrc

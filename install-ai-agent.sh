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

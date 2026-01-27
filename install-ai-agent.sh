#!/bin/bash
set -ex

# openspec
npm install -g @fission-ai/openspec@latest

# 全局配置
echo "prefix=/root/.npm-packages" > /opt/node/lib/node_modules/npm/npmrc

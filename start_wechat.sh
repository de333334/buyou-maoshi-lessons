#!/usr/bin/env bash
# 启动「微信可打开」的课程服务 + 公网隧道
# 用法（在 Git Bash 里运行）： bash start_wechat.sh
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# 关掉旧的服务与隧道
pkill -f "_serve.js" 2>/dev/null || true
pkill -f "serveo.net" 2>/dev/null || true
sleep 1

# 起本地静态服务（端口 8848，根=微信课堂落地页 index.html）
node _serve.js >/tmp/serve.log 2>&1 &
sleep 2

# 起免费公网隧道（serveo.net，无需账号）
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ServerAliveInterval=30 \
    -R 80:localhost:8848 serveo.net >/tmp/serveo.log 2>&1 &
sleep 10

echo "============================================"
echo " 微信里打开下面这个地址即可听晓晓老师讲课："
echo "============================================"
grep -oE 'https://[a-zA-Z0-9.-]+\.serveousercontent\.com' /tmp/serveo.log | head -1
echo "（提示：本机需保持开机、此窗口/进程不关闭；重启会得到新地址）"

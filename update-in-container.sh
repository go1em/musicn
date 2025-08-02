#!/bin/bash

echo "开始更新musicn..."

# 进入应用目录
cd /app

# 备份当前版本
echo "备份当前版本..."
cp -r . ../backup_$(date +%Y%m%d_%H%M%S)

# 拉取最新代码
echo "拉取最新代码..."
git fetch origin
git reset --hard origin/main

# 安装依赖
echo "安装依赖..."
npm install

# 构建项目
echo "构建项目..."
npm run build

# 重启服务
echo "重启服务..."
pkill -f "node.*cli.js" || true
sleep 2

# 启动新服务
echo "启动新服务..."
nohup node ./bin/cli.js --qrcode > /app/logs/app.log 2>&1 &

echo "更新完成！"
echo "服务已重启，请检查日志: tail -f /app/logs/app.log" 
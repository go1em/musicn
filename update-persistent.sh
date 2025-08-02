#!/bin/bash

echo "开始持久化更新musicn..."

# 设置宿主机挂载目录
HOST_DIR="/volume1/docker/musicn/app"
CONTAINER_DIR="/app"

# 确保宿主机目录存在
mkdir -p $HOST_DIR

# 进入应用目录
cd $CONTAINER_DIR

# 备份当前版本
echo "备份当前版本..."
cp -r . $HOST_DIR/backup_$(date +%Y%m%d_%H%M%S)

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

# 将更新后的代码复制到宿主机
echo "保存更新到宿主机..."
cp -r . $HOST_DIR/

# 重启服务
echo "重启服务..."
pkill -f "node.*cli.js" || true
sleep 2

# 启动新服务
echo "启动新服务..."
nohup node ./bin/cli.js --qrcode > /app/logs/app.log 2>&1 &

echo "持久化更新完成！"
echo "更新后的代码已保存到: $HOST_DIR"
echo "服务已重启，请检查日志: tail -f /app/logs/app.log" 
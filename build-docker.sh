#!/bin/bash

# 设置镜像名称和标签
IMAGE_NAME="go1em/musicn"
TAG="latest"

echo "开始构建优化的Docker镜像..."

# 构建镜像
docker build -t $IMAGE_NAME:$TAG .

if [ $? -eq 0 ]; then
    echo "镜像构建成功！"
    
    # 显示镜像大小
    echo "镜像大小:"
    docker images $IMAGE_NAME:$TAG --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
    
    echo ""
    echo "要推送到Docker Hub，请运行:"
    echo "docker push $IMAGE_NAME:$TAG"
    echo ""
    echo "要在群晖上更新，请:"
    echo "1. 在群晖Docker中停止当前容器"
    echo "2. 删除旧镜像"
    echo "3. 拉取新镜像: docker pull $IMAGE_NAME:$TAG"
    echo "4. 使用新镜像重新创建容器"
else
    echo "镜像构建失败！"
    exit 1
fi 
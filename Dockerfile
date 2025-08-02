# 使用多阶段构建来减小镜像大小
FROM node:18-alpine AS builder

WORKDIR /app

# 复制package文件
COPY package*.json ./
COPY pnpm-lock.yaml ./

# 安装依赖
RUN npm install -g pnpm && \
    pnpm install

# 复制源代码
COPY . .

# 构建项目
RUN pnpm run build

# 生产阶段 - 使用更小的基础镜像
FROM node:18-alpine AS production

# 安装必要的运行时依赖
RUN apk add --no-cache dumb-init

WORKDIR /app

# 只复制必要的文件
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/template ./template
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./

# 只安装生产依赖
RUN npm install --only=production

# 创建下载目录
RUN mkdir -p /data

# 暴露端口
EXPOSE 7478

# 设置环境变量
ENV DOWNLOAD_PATH=/data
ENV NODE_ENV=production

# 使用dumb-init作为入口点
ENTRYPOINT ["dumb-init", "--"]

# 启动命令
CMD ["node", "./bin/cli.js", "--qrcode"] 
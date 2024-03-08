#!/bin/sh

set -e

# 复制Nginx、服务配置配置
sudo cp -r ./tools/centos/* /

# 复制后端服务到运行目录
sudo rm -rf /data/wwwroot/server
sudo cp -r ./server /data/wwwroot/

# 创建游戏引擎服务端运行目录
if [ ! -d "/data/wwwroot/game" ]; then
    mkdir -p /data/wwwroot/game
fi

sudo chmod +x /data/wwwroot/game/*

# 编译后端服务
cd /data/wwwroot/server/
/usr/local/go/bin/go env -w GOSUMDB=off
export GO111MODULE=on && export GOPROXY=https://goproxy.io && /usr/local/go/bin/go build main.go

# 重启Nginx服务
sudo systemctl restart nginx.service

# 重启后端服务和游戏服务
sudo systemctl daemon-reload
sudo systemctl enable server.service
sudo systemctl restart server.service
sudo systemctl enable game.service
sudo systemctl restart game.service
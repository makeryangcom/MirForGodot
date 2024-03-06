#!/bin/sh

set -e

# 更新系统并安装一些常用软件和依赖
sudo yum update -y && sudo yum install -y vim curl git openssl openssl-devel

# 安装Nginx(安装后启动、设置为开机自启动)
yum install -y nginx
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

# 设置防火墙规则并重启防火墙
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9000/udp --permanent
sudo firewall-cmd --reload

# 安装Golang编译环境
if [ ! -d "/usr/local/go/bin/" ]; then
    wget https://studygolang.com/dl/golang/go1.19.4.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
    sudo sh -c 'echo "export PATH=/usr/local/go/bin:$PATH" >> /etc/profile'
    # shellcheck disable=SC2039
    # shellcheck disable=SC1090
    source /etc/profile && source ~/.bashrc
    sudo rm -rf go1.19.4.linux-amd64.tar.gz
fi

# 安装Redis、MySQL数据库
if [ ! -d "/data/mysql" ]; then
    wget -c http://mirrors.oneinstack.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && ./oneinstack/install.sh --db_option 2 --dbinstallmethod 1 --dbrootpwd 88888888 --redis
    sudo rm -rf oneinstack-full.tar.gz
    sudo rm -rf oneinstack*
fi
#!/bin/sh

set -e

sudo yum update -y

sudo yum install -y epel-release git curl wget vim tree nginx multitail openssl openssl-devel

if [ ! -d "/usr/local/go/bin/" ]; then
    wget https://studygolang.com/dl/golang/go1.22.0.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
    sudo sh -c 'echo "export PATH=/usr/local/go/bin:$PATH" >> /etc/profile'
    # shellcheck disable=SC2039
    # shellcheck disable=SC1090
    source /etc/profile && source ~/.bashrc
    sudo rm -rf go1.22.0.linux-amd64.tar.gz
fi

if [ ! -d "/data/mysql" ]; then
    wget -c http://mirrors.oneinstack.com/oneinstack.tar.gz && tar xzf oneinstack.tar.gz && ./oneinstack/install.sh --db_option 2 --dbinstallmethod 1 --dbrootpwd 88888888 --redis
    sudo rm -rf oneinstack*
fi

rm -rf /data/tlinux

sudo cp -r ./centos/* /

sudo cp -r ../service /data/wwwroot/

# sudo systemctl stop firewalld && sudo systemctl disable firewalld

sudo systemctl restart nginx.service && sudo systemctl enable nginx.service

sudo systemctl daemon-reload
sudo systemctl enable service.service
sudo systemctl restart service.service
sudo systemctl enable engine.service
sudo systemctl restart engine.service




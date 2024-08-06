#!/bin/sh

set -e

sudo rm -rf /etc/nginx/conf.d/* && sudo rm -rf /etc/nginx/ssl/* && sudo rm -rf /data/wwwroot/service/*

sudo cp -r ./centos/* /

sudo cp -r ../service /data/wwwroot/
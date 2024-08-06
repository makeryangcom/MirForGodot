#!/bin/sh

set -e

cd /data/wwwroot/service/

/usr/local/go/bin/go env -w GOSUMDB=off
/usr/local/go/bin/go env -w GOPATH=/data/golang
/usr/local/go/bin/go env -w GOMODCACHE=/data/golang/pkg/mod

export GO111MODULE=on && export GOPROXY=https://goproxy.io && /usr/local/go/bin/go build main.go

sudo systemctl restart nginx.service && sudo systemctl enable nginx.service

sudo systemctl restart service.service && sudo systemctl restart engine.service
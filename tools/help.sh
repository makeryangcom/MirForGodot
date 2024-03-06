#!/bin/sh

set -e

GRAY='\033[1;30m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

# shellcheck disable=SC2039
echo -e "${YELLOW}一些常用的命令脚本：${NC}"

echo -e "${GRAY}查看所有服务状态${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo systemctl status server.service game.service${NC}"

# shellcheck disable=SC2039
echo -e "${GRAY}重启后端服务${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo systemctl restart server.service${NC}"
# shellcheck disable=SC2039
echo -e "${GRAY}重启游戏服务器${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo systemctl restart game.service${NC}"

# shellcheck disable=SC2039
echo -e "${GRAY}监听后端服务实时日志${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo journalctl -fu server.service${NC}"
# shellcheck disable=SC2039
echo -e "${GRAY}监听游戏服务器实时日志${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo journalctl -fu game.service${NC}"
# shellcheck disable=SC2039

echo -e "${GRAY}重启Nginx服务${NC}"
# shellcheck disable=SC2039
echo -e "${GREEN}sudo systemctl restart nginx.service${NC}"
# shellcheck disable=SC2039
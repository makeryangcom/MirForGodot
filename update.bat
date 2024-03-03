@echo off

scp -r ./engine/release/server* root@172.21.254.81:/data/wwwroot/game/

ssh root@172.21.254.81 "chmod +x /data/wwwroot/game/* && cd /opt/Engine2D && sudo ./tools/update.sh"
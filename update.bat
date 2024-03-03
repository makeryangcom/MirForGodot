@echo off

scp -r ./engine/release/server* root@172.21.255.206:/data/wwwroot/game/

ssh root@172.21.255.206 "chmod +x /data/wwwroot/game/* && cd /opt/Engine2D && sudo ./tools/update.sh"
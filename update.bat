@echo off
set MIR_REMOTE_IP=119.45.176.126
ssh root@%MIR_REMOTE_IP% "systemctl stop engine.service"
scp -r ./engine/release/engine.x86_64 root@%MIR_REMOTE_IP%:/data/wwwroot/engine/
ssh root@%MIR_REMOTE_IP% "chmod +x /data/wwwroot/engine/engine.x86_64 && systemctl restart engine.service"
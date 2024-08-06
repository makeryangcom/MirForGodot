#!/bin/sh

set -e

sudo systemctl status service.service engine.service

# sudo journalctl -fu service.service -fu engine.service
sudo multitail -l "journalctl -fu service.service" -l "journalctl -fu engine.service"

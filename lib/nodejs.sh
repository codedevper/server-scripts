#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Node"
echo "======================================"

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
sudo apt install -y nodejs

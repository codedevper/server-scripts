#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

sudo apt install redis-server -y

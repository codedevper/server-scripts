#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Dev Repository"
echo "======================================"

sudo apt install -y wget gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano quota

source ./lib/nodejs.sh

#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Wordpress CLI"
echo "======================================"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

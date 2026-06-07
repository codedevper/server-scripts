#!/usr/bin/env bash

set -e

echo "======================================"
echo " Install Server"
echo "======================================"

sudo apt update
sudo apt install sqlite3 -y
sudo apt install mariadb-server mariadb-client -y
sudo apt install redis-server -y
sudo apt install sendmail -y

sqlite3 --version
mysql --version
redis-server --version

echo "======================================"
echo " Install Wordpress CLI"
echo "======================================"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

echo "======================================"
echo " Install Linux Quota Management"
echo "======================================"

sudo apt install quota -y

echo "======================================"
echo " Installation Complete"
echo "======================================"
echo ""
echo "Please login and run:"
echo ""
echo "sudo mariadb-secure-installation"
echo "sudo apt install phpmyadmin"
echo ""
echo "to use mysql without sudo."

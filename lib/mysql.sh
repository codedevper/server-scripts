#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

sudo apt install mariadb-server mariadb-client -y

mysql --version

echo "==> Adding user to database..."
sudo mysql
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS test;
DROP USER IF EXISTS 'test'@'localhost;
CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';
FLUSH PRIVILEGES;
EXIT;

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

#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing MySQL ..."
sudo apt install -y mysql-server

echo "==> Adding user to database..."
sudo mysql
CREATE DATABASE server;
CREATE USER 'server'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON server.* TO 'server'@'localhost';
FLUSH PRIVILEGES;
EXIT;

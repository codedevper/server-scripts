#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing MySQL ..."
sudo apt install -y mysql-server

echo "==> Adding user to database..."
sudo mysql
CREATE DATABASE test;
CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON test.* TO 'test'@'localhost';
FLUSH PRIVILEGES;
EXIT;
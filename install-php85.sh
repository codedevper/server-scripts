#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing required packages (curl, git, software-properties-common)..."
sudo apt install -y curl git software-properties-common

echo "==> Adding ondrej/php repository..."
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

echo "==> Updating package list again..."
sudo apt update

echo "==> Installing PHP 8.5..."
sudo apt install -y php8.5

echo "==> Checking PHP version..."
php -v

echo "✅ PHP 8.5 installation completed."
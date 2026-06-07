#!/usr/bin/env bash

set -e

echo "======================================"
echo " Install Wordpress CLI"
echo "======================================"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

sudo rm -rf /srv/www/panel
sudo userdel -r server
useradd -r -m -s /bin/bash server

git clone https://github.com/codedevper/master-panel.git /srv/www/panel

sudo chown -R server:server /srv/www/panel

sudo -u server bash -c '
cd /srv/www/panel
composer setup
'

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
echo ""
echo "cd /srv/panel && composer run dev"

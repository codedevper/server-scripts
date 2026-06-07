#!/usr/bin/env bash

set -e

echo "======================================"
echo " Install Wordpress CLI"
echo "======================================"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

sudo userdel -r panel

useradd -r -m -d /srv/panel -s /bin/bash panel

git clone https://github.com/codedevper/master-panel.git /srv/panel

sudo chown -R panel:panel /srv/panel

sudo -u panel bash -c '
cd /srv/panel
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

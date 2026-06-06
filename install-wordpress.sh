#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing WP CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

sudo rm -rf /var/www/wordpress

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

sudo mv wordpress /var/www/wordpress
cd /var/www/wordpress

sudo mysql
DROP DATABASE IF EXISTS wordpress;
CREATE DATABASE IF NOT EXISTS wordpress;
DROP USER IF EXISTS 'wordpress'@'localhost;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;
EXIT;

wp config create \
  --dbname=wordpress \
  --dbuser=wordpress \
  --dbpass=password \
  --dbhost=localhost

wp db create

wp core install \
  --url=localhost \
  --title="Wordpress" \
  --admin_user=admin \
  --admin_password=password \
  --admin_email=admin@email.com

wp plugin install \
woocommerce \
custom-smtp \
simple-jwt-login \
--activate

sudo chown -R www-data:www-data /var/www/wordpress
sudo chmod -R 755 /var/www/wordpress

sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/wordpress
    <Directory /var/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2ensite wordpress.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

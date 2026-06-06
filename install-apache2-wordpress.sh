#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing required packages (apache2, php, mysql)..."
sudo apt install -y apache2 php libapache2-mod-php mysql-server php-mysql

echo "==> Adding user to database..."
sudo mysql
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;
EXIT;

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

wp --info

wp core download --path=/srv/www/wordpress

cd /srv/www/wordpress

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

sudo chown -R www-data:www-data /srv/www/wordpress
sudo chmod -R 755 /srv/www/wordpress

sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2ensite wordpress.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

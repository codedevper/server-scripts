#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing required packages (apache2, php, mysql)..."
sudo apt install -y apache2 php libapache2-mod-php mysql-server php-mysql

echo "==> Adding user to database..."
sudo mysql
CREATE DATABASE wordpress;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;
EXIT;

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

sudo mv wordpress /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

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

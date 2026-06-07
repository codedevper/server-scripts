#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Dev Repository"
echo "======================================"

sudo apt install -y wget gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano quota

echo "======================================"
echo " Install PHP"
echo "======================================"

# Update the package lists.
sudo apt update

# Install PHP.
sudo apt install -y php

php -v

echo "======================================"
echo " Install multiple PHP extensions"
echo "======================================"

sudo apt-get install -y \
    libgd3 \
    php-cli \
    php-dev \
    php-pgsql \
    php-sqlite3 \
    php-gd \
    php-curl \
    php-mongodb \
    php-imap \
    php-mysql \
    php-mbstring \
    php-mcrypt \
    php-xml \
    php-zip \
    php-bcmath \
    php-bz2 \
    php-soap \
    php-intl \
    php-readline \
    php-ldap \
    php-msgpack \
    php-igbinary \
    php-redis \
    php-swoole \
    php-memcached \
    php-pcov \
    php-imagick \
    php-xdebug

echo "======================================"
echo " Install Composer"
echo "======================================"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

composer --version

echo "======================================"
echo " Install Node"
echo "======================================"

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.22.3".

# Verify npm version:
npm -v # Should print "10.9.8".

echo "======================================"
echo " Install Server"
echo "======================================"

sudo apt update

sudo apt install mariadb-server mariadb-client -y
sudo apt install redis-server -y
sudo apt install sendmail -y

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
echo " Installation Complete"
echo "======================================"
echo ""
echo "Please login and run:"
echo ""
echo "sudo mariadb-secure-installation"
echo "sudo apt install phpmyadmin"
echo ""
echo "to use mysql without sudo."

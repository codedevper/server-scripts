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
echo " Install Node"
echo "======================================"

curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
apt install -y nodejs

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
echo " Install PHP"
echo "======================================"

# Add the packages.sury.org/php repository.
sudo apt update
sudo apt install -y lsb-release ca-certificates curl
sudo curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
sudo dpkg -i /tmp/debsuryorg-archive-keyring.deb
sudo tee /etc/apt/sources.list.d/php.sources <<EOF
Types: deb
URIs: https://packages.sury.org/php/
Suites: $(lsb_release -sc)
Components: main
Signed-By: /usr/share/keyrings/debsuryorg-archive-keyring.gpg
EOF
sudo apt update

# Install PHP.
sudo apt install -y php8.4

php -v

echo "======================================"
echo " Install multiple PHP extensions"
echo "======================================"

sudo apt-get install -y \
    libgd3 \
    php8.4-cli \
    php8.4-dev \
    php8.4-pgsql \
    php8.4-sqlite3 \
    php8.4-gd \
    php8.4-curl \
    php8.4-mongodb \
    php8.4-imap \
    php8.4-mysql \
    php8.4-mbstring \
    php8.4-mcrypt \
    php8.4-xml \
    php8.4-zip \
    php8.4-bcmath \
    php8.4-bz2 \
    php8.4-soap \
    php8.4-intl \
    php8.4-readline \
    php8.4-ldap \
    php8.4-msgpack \
    php8.4-igbinary \
    php8.4-redis \
    php8.4-swoole \
    php8.4-memcached \
    php8.4-pcov \
    php8.4-imagick \
    php8.4-xdebug

echo "======================================"
echo " Install Composer"
echo "======================================"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
EXPECTED_CHECKSUM="$(curl -fsSL https://composer.github.io/installer.sig)"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        echo "ERROR: Invalid installer checksum"
        rm -f composer-setup.php
        exit 1
    fi

php composer-setup.php
rm -f composer-setup.php

mv composer.phar /usr/local/bin/composer

composer --version

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

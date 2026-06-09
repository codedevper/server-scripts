#!/usr/bin/env bash

set -e

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Dev Repository"
echo "======================================"

sudo apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano quota

# Add the ondrej/php repository.
sudo apt update
sudo apt install -y software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP.
sudo apt install -y php8.4

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
php8.4-xml \
php8.4-zip \
php8.4-bcmath \
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

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
sudo apt install -y nodejs

node -v

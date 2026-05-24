#!/usr/bin/env bash

set -e

PHP_VERSION="8.5"
NVM_VERSION="v0.40.4"
NODE_VERSION="24"

echo "======================================"
echo " Update Ubuntu"
echo "======================================"

sudo apt update
sudo apt upgrade -y

echo "======================================"
echo " Install PHP Repository"
echo "======================================"

sudo apt install -y software-properties-common
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt update

echo "======================================"
echo " Install PHP ${PHP_VERSION}"
echo "======================================"

sudo apt install -y \
php${PHP_VERSION} \
php${PHP_VERSION}-cli \
php${PHP_VERSION}-dev \
php${PHP_VERSION}-pgsql \
php${PHP_VERSION}-sqlite3 \
php${PHP_VERSION}-gd \
php${PHP_VERSION}-curl \
php${PHP_VERSION}-mongodb \
php${PHP_VERSION}-imap \
php${PHP_VERSION}-mysql \
php${PHP_VERSION}-mbstring \
php${PHP_VERSION}-xml \
php${PHP_VERSION}-zip \
php${PHP_VERSION}-bcmath \
php${PHP_VERSION}-soap \
php${PHP_VERSION}-intl \
php${PHP_VERSION}-readline \
php${PHP_VERSION}-ldap \
php${PHP_VERSION}-msgpack \
php${PHP_VERSION}-igbinary \
php${PHP_VERSION}-redis \
php${PHP_VERSION}-swoole \
php${PHP_VERSION}-memcached \
php${PHP_VERSION}-pcov \
php${PHP_VERSION}-imagick \
php${PHP_VERSION}-xdebug \
libgd3

echo "======================================"
echo " Install Composer"
echo "======================================"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

EXPECTED_CHECKSUM=$(curl -s https://composer.github.io/installer.sig)

ACTUAL_CHECKSUM=$(php -r "echo hash_file('sha384', 'composer-setup.php');")

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
echo "ERROR: Invalid Composer installer checksum"
rm composer-setup.php
exit 1
fi

php composer-setup.php

rm composer-setup.php

sudo mv composer.phar /usr/local/bin/composer

composer --version

echo "======================================"
echo " Install NVM"
echo "======================================"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "======================================"
echo " Install Node.js ${NODE_VERSION}"
echo "======================================"

nvm install ${NODE_VERSION}
nvm use ${NODE_VERSION}
nvm alias default ${NODE_VERSION}

node -v
npm -v

echo "======================================"
echo " Remove Old Docker"
echo "======================================"

sudo apt remove -y \
docker.io \
docker-compose \
docker-compose-v2 \
docker-doc \
podman-docker \
containerd \
runc || true

echo "======================================"
echo " Install Docker"
echo "======================================"

sudo apt update
sudo apt install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL 
https://download.docker.com/linux/ubuntu/gpg 
-o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

sudo usermod -aG docker $USER

docker --version
docker compose version

echo "======================================"
echo " Installation Complete"
echo "======================================"
echo ""
echo "Please logout/login or run:"
echo ""
echo "newgrp docker"
echo ""
echo "to use Docker without sudo."

#!/usr/bin/env bash

set -e

echo "==> Updating package list..."
sudo apt update

echo "==> Installing required packages (curl, git, software-properties-common)..."
sudo apt install -y gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano

echo "==> Adding ondrej/php repository..."
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

echo "==> Updating package list again..."
sudo apt update

echo "==> Installing PHP 8.5..."
sudo apt install -y php8.5 php8.5-fpm
sudo apt-get install -y \
    libgd3 \
    php8.5-cli \
    php8.5-dev \
    php8.5-pgsql \
    php8.5-sqlite3 \
    php8.5-gd \
    php8.5-curl \
    php8.5-mongodb \
    php8.5-imap \
    php8.5-mysql \
    php8.5-mbstring \
    php8.5-xml \
    php8.5-zip \
    php8.5-bcmath \
    php8.5-soap \
    php8.5-intl \
    php8.5-readline \
    php8.5-ldap \
    php8.5-msgpack \
    php8.5-igbinary \
    php8.5-redis \
    php8.5-swoole \
    php8.5-memcached \
    php8.5-pcov \
    php8.5-imagick \
    php8.5-xdebug

echo "==> Checking PHP version..."
php -v

echo "==> Installing Composer ..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo "==> Checking Composer version..."
composer -V

echo "==> Installing NVM ..."
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

echo "==> Installing Node.js ..."
# Download and install Node.js:
nvm install 24

echo "==> Checking Node.js version..."
# Verify the Node.js version:
node -v # Should print "v24.15.0".

# Verify npm version:
npm -v # Should print "11.12.1".

echo "==> Installing Docker ..."
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER
sudo systemctl start docker

sudo apt-get install -y mysql-client
sudo apt-get install -y mariadb-client
sudo apt-get install -y postgresql-client-18

echo "✅ Runtimes 852418 installation completed."

#!/usr/bin/env bash

echo "======================================"
echo " Update package"
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo " Install Dev Repository"
echo "======================================"

sudo apt install -y wget gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3 libcap2-bin libpng-dev python3 dnsutils librsvg2-bin fswatch ffmpeg nano

echo "======================================"
echo " Install PHP Repository"
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

echo "======================================"
echo " Install PHP 8.5"
echo "======================================"

sudo apt install -y php8.5

php -v

echo "======================================"
echo " Install multiple PHP 8.5 extensions"
echo "======================================"

sudo apt-get install -y \
    libgd3 \
    php8.5-cli \
    php8.5-dev \
    php8.5-common \
    php8.5-pgsql \
    php8.5-sqlite3 \
    php8.5-gd \
    php8.5-curl \
    php8.5-mongodb \
    php8.5-imap \
    php8.5-mysql \
    php8.5-mbstring \
    php8.5-mcrypt \
    php8.5-xml \
    php8.5-zip \
    php8.5-bcmath \
    php8.5-bz2 \
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
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.16.0".

# Verify npm version:
npm -v # Should print "11.13.0".

echo "======================================"
echo " Install Server"
echo "======================================"

sudo apt update
sudo apt install sqlite3 -y
sudo apt install mariadb-server mariadb-client -y
sudo apt install redis-server -y
sudo apt install sendmail -y

sqlite3 --version
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
echo " Install Linux Quota Management"
echo "======================================"

sudo apt install quota -y

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

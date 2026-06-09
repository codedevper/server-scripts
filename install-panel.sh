#!/usr/bin/env bash

set -e

rm -rf /srv/www/panel

if id "server" >/dev/null 2>&1; then
    userdel -r server
fi

useradd -r -m -s /bin/bash server

git clone https://github.com/codedevper/master-panel.git /srv/www/panel

sudo chown -R server:server /srv/www/panel
sudo chmod -R 775 /var/www/panel/storage
sudo chmod -R 775 /var/www/panel/bootstrap/cache

sudo -u server bash -c '
cd /srv/www/panel

composer setup
'

#sudo cp -a /srv/www/panel/supervisor/conf.d/. /etc/supervisor/conf.d/

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status

#!/usr/bin/env bash

set -e

rm -rf /srv/www/panel

if id "supervisor" >/dev/null 2>&1; then
    userdel -r supervisor
fi

useradd -r -m -s /bin/bash supervisor

git clone https://github.com/codedevper/master-panel.git /srv/www/panel

sudo chown -R supervisor:supervisor /srv/www/panel

sudo -u supervisor bash -c '
cd /srv/www/panel

composer setup

sudo cp -a /srv/supervisor/conf.d/. /etc/supervisor/conf.d/

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status
'

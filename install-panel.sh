#!/usr/bin/env bash

set -e

sudo rm -rf /var/www/panel

if id "supervisor" >/dev/null 2>&1; then
    sudo userdel -r supervisor || true
fi

sudo useradd -r -m -s /bin/bash supervisor

git clone https://github.com/codedevper/master-panel.git /var/www/panel

sudo chown -R supervisor:supervisor /var/www/panel

sudo -u supervisor bash -c '
cd /var/www/panel

composer setup
'

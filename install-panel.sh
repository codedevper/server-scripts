#!/usr/bin/env bash

set -e

rm -rf /var/www/panel

if id "supervisor" >/dev/null 2>&1; then
    userdel -r supervisor || true
fi

useradd -r -m -s /bin/bash supervisor

git clone https://github.com/codedevper/master-panel.git /var/www/panel

sudo chown -R supervisor:supervisor /var/www/panel

sudo -u supervisor bash -c '
cd /var/www/panel

composer setup
'

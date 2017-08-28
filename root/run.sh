#!/bin/bash
set -eu

cp -av /root/etc /data
mkdir -p /data/logs

exec /usr/bin/supervisord -n -c /root/etc/supervisor.conf


#!/bin/bash
set -eu
cp -f /etc/resolv.conf /etc/resolv.dnsmasq.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf
exec /usr/bin/supervisord -n -c /data/etc/supervisor.conf

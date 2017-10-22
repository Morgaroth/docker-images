#!/bin/sh

set -e
if [ ! -e '/config/minidlna.conf' ]; then
	cp /etc/minidlna.conf /config/minidlna.conf
fi

exec /usr/sbin/minidlnad -d -f /config/minidlna.conf $@

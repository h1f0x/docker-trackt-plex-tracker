#!/usr/bin/env bash

if [ ! -f /config/config.ini ]; then
    cp -r /opt/trakt-plex-tracker/config.docker.ini /config/config.ini
fi

# recreate symlink
ln -sf /config/config.ini /opt/trakt-plex-tracker/config.ini

# run script at boot
export LD_LIBRARY_PATH=/usr/local/lib/ && /usr/bin/python3.6 /opt/trakt-plex-tracker/trakt-or.py
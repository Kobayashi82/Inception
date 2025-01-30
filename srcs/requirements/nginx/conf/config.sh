#!/bin/bash

# Create the directories
mkdir -p /var/www/adminer /var/www/inception

# Copy favicon
if [ -f /usr/share/favicon.ico ]; then
    cp /usr/share/favicon.ico /var/www/favicon.ico
fi

# Copy index.html
if [ -f /usr/share/index.html ]; then
    cp /usr/share/index.html /var/www/index.html
fi

# Copy the web site
if [ -d /usr/share/inception ]; then
    cp -r /usr/share/inception /var/www
fi

# Execute Nginx
exec nginx -g "daemon off;"
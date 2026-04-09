#!/bin/bash

su -l vzurera -c "cd && make"

echo 'vagrant ssh -- -X -t "firefox"'
echo 'vagrant ssh -- -X -t "filezilla"'

# docker compose -f srcs/docker-compose.yml up -d --build --force-recreate wordpress nginx

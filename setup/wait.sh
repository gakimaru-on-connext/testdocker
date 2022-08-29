#!/bin/sh
echo wait for mount
for ((i=0; i < 10; i++)); do
    if [ -f /vagrant/docker/docker-compose.yml ]; then
        break
    fi
    sleep 1
done


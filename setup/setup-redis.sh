#!/bin/sh

echo Setup Redis

dnf -y install redis

systemctl start redis
systemctl enable redis
systemctl status redis

REDIS_CONF_PATH=/etc/redis/redis.conf 

sed -i 's/\(^bind 127.0.0.1 -::1\)/#\1/' $REDIS_CONF_PATH
sed -i "/^#bind 127.0.0.1 -::1/a bind * -::*" $REDIS_CONF_PATH

systemctl restart postgresql-14.service

firewall-cmd --add-port=6379/tcp --permanent
firewall-cmd --reload

# client
# $ curl http://192.168.56.10

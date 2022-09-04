#!/bin/sh

echo Setup Docker

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y update
dnf -y install docker-ce --allowerasing

usermod -aG docker vagrant

PEM_SRC=/vagrant/setup/config/docker/server-cert
PEM_DST=/opt/docker/cert
mkdir -p $PEM_DST
chmod 500 $PEM_DST
/bin/cp -f $PEM_SRC/ca.pem \
           $PEM_SRC/server-cert.pem \
           $PEM_SRC/server-key.pem \
           $PEM_DST/.
chmod 400 $PEM_DST/*
ls -lat $PEM_DST

sed -i -e "s,-H fd:// --containerd,-H fd:// --tlsverify --tlscacert=$PEM_DST/ca.pem --tlscert=$PEM_DST/server-cert.pem --tlskey=$PEM_DST/server-key.pem -H tcp://0.0.0.0:2376 --containerd," /usr/lib/systemd/system/docker.service

systemctl daemon-reload
systemctl start docker
systemctl enable docker
systemctl status docker

firewall-cmd --add-port=2376/tcp --permanent
firewall-cmd --reload

# client(mac)
# $ brew install docker   ※注）cask ではない（cask は Docker Desktop）
# $ brew install docker-compose
# $ mkdir -p ~/.docker/testdocker
# $ cp setup/config/docker/ca/ca.pem ~/.docker/testdocker/.
# $ cp setup/config/docker/ca/client-cert.pem ~/.docker/testdocker/cert.pem
# $ cp setup/config/docker/ca/client-key.pem ~/.docker/testdocker/key.pem
# $ export DOCKER_TLS_VERIFY="1"
# $ export DOCKER_HOST="tcp://192.168.56.10:2376"
# $ export DOCKER_CERT_PATH="$HOME/.docker/testdocker"
# $ export DOCKER_MACHINE_NAME="testdocker"
# $ docker version

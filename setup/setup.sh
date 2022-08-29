#!/bin/sh
echo setup
#hostname -b testdocker.localdomain
hostnamectl set-hostname testdocker.localdomain
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y update
dnf -y install docker-ce --allowerasing
usermod -aG docker vagrant
PEM_SRC=/vagrant/docker/ca
PEM_DST=/var/lib/docker/ca
mkdir -p $PEM_DST
cp $PEM_SRC/*.pem $PEM_DST/.
chmod 500 $PEM_DST
chmod 400 $PEM_DST/*
sed -i -e "s,-H fd:// --containerd,-H fd:// --tlsverify --tlscacert=$PEM_DST/ca.pem --tlscert=$PEM_DST/server-cert.pem --tlskey=$PEM_DST/server-key.pem -H tcp://0.0.0.0:2376 --containerd," /usr/lib/systemd/system/docker.service
firewall-cmd --add-port=2376/tcp --permanent
firewall-cmd --reload
systemctl daemon-reload
systemctl start docker
systemctl enable docker

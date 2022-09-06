#!/bin/sh

echo Setup Docker

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y update
dnf -y install docker-ce --allowerasing

usermod -aG docker vagrant

# for server
PEM_SRC=/vagrant/docker/ca
PEM_DST=/opt/docker/cert
mkdir -p $PEM_DST
chmod 500 $PEM_DST
/bin/cp -f $PEM_SRC/ca.pem \
           $PEM_SRC/server-cert.pem \
           $PEM_SRC/server-key.pem \
           $PEM_DST/.
chmod 400 $PEM_DST/ca.pem \
          $PEM_DST/server-cert.pem \
          $PEM_DST/server-key.pem
ls -lat $PEM_DST

# for client
# PEM_SRC=/vagrant/docker/ca
# PEM_DST=/opt/docker/cert
# mkdir -p $PEM_DST
# chmod 555 $PEM_DST
# /bin/cp -f $PEM_SRC/ca.pem $PEM_DST/.
# /bin/cp -f $PEM_SRC/client-cert.pem $PEM_DST/cert.pem
# /bin/cp -f $PEM_SRC/client-key.pem $PEM_DST/key.pem
# chmod 444 $PEM_DST/ca.pem \
#           $PEM_DST/cert.pem \
#           $PEM_DST/key.pem
# ls -lat $PEM_DST

sed -i -e "s,-H fd:// --containerd,-H fd:// --tlsverify --tlscacert=$PEM_DST/ca.pem --tlscert=$PEM_DST/server-cert.pem --tlskey=$PEM_DST/server-key.pem -H tcp://0.0.0.0:2376 --containerd," /usr/lib/systemd/system/docker.service

systemctl daemon-reload
systemctl start docker
systemctl enable docker
systemctl status docker

firewall-cmd --add-port=2376/tcp --permanent
firewall-cmd --reload

# project user
# PROJ_USER=vagrant
# PROJ_GROUP=vagrant
# cat <<EOD > /home/$PROJ_USER/.bashrc.docker
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://127.0.0.1:2376"
# export DOCKER_CERT_PATH="/opt/docker/cert"
# export DOCKER_MACHINE_NAME="testdocker"
# EOD
# echo "source ~/.bashrc.docker" >> /home/$PROJ_USER/.bashrc
# chown $PROJ_USER:$PROJ_GROUP /home/$PROJ_USER/.bashrc.docker

# client(mac)
# $ brew install docker   ※注）cask ではない（cask は Docker Desktop）
# $ brew install docker-compose
# $ mkdir -p ~/.docker/testdocker
# $ cp docker/ca/ca.pem ~/.docker/testdocker/.
# $ cp docker/ca/client-cert.pem ~/.docker/testdocker/cert.pem
# $ cp docker/ca/client-key.pem ~/.docker/testdocker/key.pem
# $ export DOCKER_TLS_VERIFY="1"
# $ export DOCKER_HOST="tcp://192.168.56.10:2376"
# $ export DOCKER_CERT_PATH="$HOME/.docker/testdocker"
# $ export DOCKER_MACHINE_NAME="testdocker"
# $ docker version

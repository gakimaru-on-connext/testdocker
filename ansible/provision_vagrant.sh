#!/bin/sh -e

CURDIR=$(cd $(dirname $0);pwd)

TARGET_INVENTORY=vagrant
TARGET_SITE=all_setup

source $CURDIR/_provision.rc

# Vagrant 専用処理
# 注）~/.ssh/known_hosts を強制的に書き換えるので注意
#force_update_known_hosts 192.168.56.10 testdocker

ansible-playbook -i $INVENTORY_FILE $SITE_FILE --extra-vars "$EXTRA_VARS" $ANSIBLE_OPT

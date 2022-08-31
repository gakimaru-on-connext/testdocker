#!/bin/sh

CURDIR=$(cd $(dirname $0);pwd)
PLAYBOOK_DIR=$CURDIR/playbook
INVENTORIES=inventories
#INVENTORIES_DIR=$PLAYBOOK_DIR/$INVENTORIES

TARGET_INVENTORY=vagrant
TARGET_SITE=all.setup

cd $PLAYBOOK_DIR
ansible-playbook -i $INVENTORIES/$TARGET_INVENTORY.hosts.yml site.$TARGET_SITE.yml

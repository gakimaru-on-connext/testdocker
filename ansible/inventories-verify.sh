#!/bin/sh

# playbook/inventories/*.hosts.yml の内容に問題がないか検証する

CURDIR=$(cd $(dirname $0);pwd)
PLAYBOOK_DIR=$CURDIR/playbook
INVENTORIES=inventories
INVENTORIES_DIR=$PLAYBOOK_DIR/$INVENTORIES

cd $INVENTORIES_DIR
for FILE in *.hosts.yml
do
    if [ "${FILE:0:1}" != "_" ]; then
        cd $PLAYBOOK_DIR
        INVENTORY_FILE=$INVENTORIES/$FILE
        echo check: $INVENTORY_FILE
        ansible-inventory -i $INVENTORY_FILE --list
        #ansible-inventory -i $INVENTORY_FILE --list -vvvv
        #ansible-inventory -i $INVENTORY_FILE --list --yaml
        #ansible-inventory -i $INVENTORY_FILE --graph
    fi
done

#!/bin/sh -e

# playbook/inventories/base/_*_hosts.yml を編集してこのスクリプトを実行すると、
# playbook/inventories/tempaltes/_*.yml と合成して、
# playbook/inventories/*_hosts.yml を生成する

CURDIR=$(cd $(dirname $0);pwd)
source $CURDIR/_env.rc

cd $INVENTORIES_BASE_DIR
for FILE in _*_hosts.yml
do
    if [ "${FILE:0:1}" = "_" -a "${FILE:1:1}" != "_" ]; then
        INVENTORY_FILE=${FILE:1}
        INVENTORY_FILE_NAME=${INVENTORY_FILE%.*}
        echo create: $INVENTORIES/$INVENTORY_FILE
        INVENTORY_PATH=$INVENTORIES_DIR/$INVENTORY_FILE
        LINES=$(sed -n '$=' $FILE)
        HOSTS_LINE=$(sed -n -e "/^  children:$/=" $FILE)
        VARS_LINE=$(sed -n -e "/^  vars:$/=" $FILE)
        HOSTS_BEGIN_LINE=$(($HOSTS_LINE + 1))
        HOSTS_END_LINE=$(($VARS_LINE - 1))
        VARS_BEGIN_LINE=$(($VARS_LINE + 1))
        VARS_END_LINE=$LINES
        if [ "$VARS_LINE" = "" ]; then
            HOSTS_END_LINE=$LINES
            unset VARS_BEGIN_LINE
            unset VARS_END_LINE
        fi
        sed -e 's/\$FILE/'$INVENTORY_FILE'/g' \
            -e 's/\$NAME/'$INVENTORY_FILE_NAME'/g' \
            $INVENTORIES_TEMPLATES_DIR/__all_header.yml > $INVENTORY_PATH
        sed -n "${HOSTS_BEGIN_LINE},${HOSTS_END_LINE}p" $FILE >> $INVENTORY_PATH
        cat $INVENTORIES_TEMPLATES_DIR/__all_groups.yml >> $INVENTORY_PATH
        cat $INVENTORIES_TEMPLATES_DIR/__all_vars.yml >> $INVENTORY_PATH
        if [ "$VARS_LINE" != "" ]; then
            sed -n "${VARS_BEGIN_LINE},${VARS_END_LINE}p" $FILE >> $INVENTORY_PATH
        fi
    fi
done
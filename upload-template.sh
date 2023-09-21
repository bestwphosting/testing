#!/bin/bash -ex
TEMPLATE_DB=20230920-template.sql
TEMPLATE_FILES=20230920-template.bestwp.hosting.tar.gz
REMOVE_TABLES=remove-all-tables.sql
HOST_SCRIPT=local-script.sh
UPDATE_URLS=update-url.sql
HOST=$1
WEBSITE_HOSTNAME=$2

[ -z "$HOST" ] || [ -z "$WEBSITE_HOSTNAME" ] && echo "No host specified" && exit 1

scp $TEMPLATE_DB $TEMPLATE_FILES $HOST_SCRIPT $REMOVE_TABLES $UPDATE_URLS ${HOST}:
ssh ${HOST} env WEBSITE_HOSTNAME=$WEBSITE_HOSTNAME ./$HOST_SCRIPT


#!/bin/bash -ex
TEMPLATE_DB=20230923-template.sql
TEMPLATE_FILES=20230921-template.bestwp.hosting.tar.gz
REMOVE_TABLES=remove-all-tables.sql
HOST_SCRIPT=local-script.sh
UPDATE_URLS=update-url.sql
HOST=$1
WEBSITE_HOSTNAME=$2
PORT=$3

[ -z "$HOST" ] || [ -z "$WEBSITE_HOSTNAME" ] && echo "No host specified" && exit 1
[ -n "$PORT" ] && PORT="-P ${PORT}"

function upload_file() {
	scp $PORT $1 ${HOST}:$2
}

upload_file $TEMPLATE_DB template.sql
upload_file $TEMPLATE_FILES template-files.tar.gz
scp $PORT $HOST_SCRIPT $REMOVE_TABLES $UPDATE_URLS ${HOST}:
ssh ${PORT/-P/-p} ${HOST} env WEBSITE_HOSTNAME=$WEBSITE_HOSTNAME ./$HOST_SCRIPT

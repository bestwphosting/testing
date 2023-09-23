#!/bin/bash -ex
PUBLIC_HTML_DIR=public_html

if [ ! -d "$PUBLIC_HTML_DIR" ]; then
	# Kinsta
	[ -d public ] && PUBLIC_HTML_DIR=public;
	# SiteGround
	[ -d "www/${WEBSITE_HOSTNAME}/public_html" ] && PUBLIC_HTML_DIR=www/${WEBSITE_HOSTNAME}/public_html
fi

TARGET_WP_CONTENT_DIR=${PUBLIC_HTML_DIR}/wp-content

echo "Checking existing DB config..."
DB_NAME=$(grep DB_NAME ${PUBLIC_HTML_DIR}/wp-config.php | cut -d"'" -f4)
DB_USER=$(grep DB_USER ${PUBLIC_HTML_DIR}/wp-config.php | cut -d"'" -f4)
DB_HOST=$(grep DB_HOST ${PUBLIC_HTML_DIR}/wp-config.php | cut -d"'" -f4)
DB_PASSWORD=$(grep DB_PASSWORD ${PUBLIC_HTML_DIR}/wp-config.php | cut -d"'" -f4)

echo "Making a backup copy of existing public_html..."
[ ! -d public_html-orig ] && cp -pR ${PUBLIC_HTML_DIR} public_html-orig
echo "Removing existing themes and uploads..."
rm -rf ${TARGET_WP_CONTENT_DIR}/themes/* ${TARGET_WP_CONTENT_DIR}/uploads/*
echo "Copying template..."
tar zxf template-files.tar.gz
if [ ! -d ${TARGET_WP_CONTENT_DIR} ]; then
	echo "Making wp-content dir..."
	mkdir -p ${TARGET_WP_CONTENT_DIR}
	chmod 0755 ${TARGET_WP_CONTENT_DIR}
fi
cp -R template.bestwp.hosting/wp-content/* ${TARGET_WP_CONTENT_DIR}/
cp template.bestwp.hosting/robots.txt ${PUBLIC_HTML_DIR}/
[ ! -f ${PUBLIC_HTML_DIR}/.htaccess ] && echo "Copying template .htaccess" && cp template.bestwp.hosting/.htaccess ${PUBLIC_HTML_DIR}/.htaccess

echo "Updating database..."
TABLE_PREFIX=$(grep table_prefix template.bestwp.hosting/wp-config.php | cut -d"'" -f2)
sed -i "s/^\$table_prefix.*/\$table_prefix = '${TABLE_PREFIX}';/" ${PUBLIC_HTML_DIR}/wp-config.php
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < remove-all-tables.sql
#sed -i "s/template.bestwp.hosting/$WEBSITE_HOSTNAME/g" 20230920-template.sql
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < template.sql
sed -i "s/%%HOST%%/$WEBSITE_HOSTNAME/g" update-url.sql
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < update-url.sql 

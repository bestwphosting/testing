#!/bin/bash -ex
echo "Checking existing DB config..."
DB_NAME=$(grep DB_NAME public_html/wp-config.php | cut -d"'" -f4)
DB_USER=$(grep DB_USER public_html/wp-config.php | cut -d"'" -f4)
DB_HOST=$(grep DB_HOST public_html/wp-config.php | cut -d"'" -f4)
DB_PASSWORD=$(grep DB_PASSWORD public_html/wp-config.php | cut -d"'" -f4)

echo "Making a backup copy of existing public_html..."
[ ! -d public_html-orig ] && cp -pR public_html public_html-orig
echo "Removing existing themes and uploads..."
rm -rf public_html/wp-content/themes/* public_html/wp-content/uploads/*
echo "Copying template..."
tar zxvf *-template.bestwp.hosting.tar.gz
cp -R template.bestwp.hosting/wp-content/* public_html/wp-content/
cp template.bestwp.hosting/robots.txt public_html/
[ ! -f public_html/.htaccess ] && echo "Copying template .htaccess" && cp template.bestwp.hosting/.htaccess public_html/.htaccess

echo "Updating database..."
TABLE_PREFIX=$(grep table_prefix template.bestwp.hosting/wp-config.php | cut -d"'" -f2)
sed -i "s/^\$table_prefix.*/\$table_prefix = '${TABLE_PREFIX}';/" public_html/wp-config.php
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < remove-all-tables.sql
#sed -i "s/template.bestwp.hosting/$WEBSITE_HOSTNAME/g" 20230920-template.sql
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < 20230920-template.sql
sed -i "s/%%HOST%%/$WEBSITE_HOSTNAME/g" update-url.sql
mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST $DB_NAME < update-url.sql 

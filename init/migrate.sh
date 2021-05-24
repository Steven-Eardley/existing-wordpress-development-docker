#!/bin/bash

##############
# migrate.sh #
##############
#
# Description: 
# Updates URL in database from OLD_URL to NEW_URL

if [ -z "$NEW_URL" ]
then
   echo "No new URL specified, keeping ${OLD_URL}"
else
  echo "Migrating wordpress DB from ${OLD_URL} to ${NEW_URL}..."
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -D$MYSQL_DATABASE -e "
  UPDATE ${WORDPRESS_TABLE_PREFIX}options SET option_value = REPLACE(option_value, '${OLD_URL}', '${NEW_URL}') WHERE option_name = 'home' OR option_name = 'siteurl'; 
  UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET guid = REPLACE(guid, '${OLD_URL}', '${NEW_URL}'); 
  UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET post_content = REPLACE(post_content, '${OLD_URL}', '${NEW_URL}'); 
  UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET post_content = REPLACE(post_content, 'src=\"${OLD_URL}\"', 'src=\"${NEW_URL}\"'); 
  UPDATE ${WORDPRESS_TABLE_PREFIX}posts SET guid = REPLACE(guid, '${OLD_URL}', '${NEW_URL}') WHERE post_type = 'attachment'; 
  UPDATE ${WORDPRESS_TABLE_PREFIX}postmeta SET meta_value = REPLACE(meta_value, '${OLD_URL}', '${NEW_URL}');"
  echo "done!"
fi

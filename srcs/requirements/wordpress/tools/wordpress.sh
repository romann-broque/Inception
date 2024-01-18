#!/bin/bash

MARIADB_HOST=${MARIADB_HOST:-mariadb}
MARIADB_IP=$(getent hosts $MARIADB_HOST | awk '{ print $1 }')
echo "$MARIADB_IP $MARIADB_HOST" >> /etc/hosts
exec 2>&1

lock_file="/var/www/html/.setup_complete"

if [ ! -f $lock_file ]; then
    cd /var/www/html
    wp core download --allow-root
    rm -f /var/www/html/wp-config.php
    wp config create --dbname=$MYSQL_DATABASE --dbhost=$MYSQL_HOST --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --allow-root --skip-check

    until wp db check --path=/var/www/html --quiet --allow-root; do
        echo "Waiting for MySQL..."
        sleep 1
    done

    wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
    wp user create $WP_SUBSCRIBER_USER $WP_SUBSCRIBER_EMAIL --role=subscriber --user_pass=$WP_SUBSCRIBER_PASSWORD --allow-root
    wp theme install twentyseventeen --activate --allow-root
    wp post delete $(wp post list --format=ids --allow-root) --allow-root
    wp post create --post_type=post --post_title="This is a post" --post_content="... and its content :)" --post_status=publish --allow-root

    echo "WordPress setup completed."
    touch $lock_file
else
    echo "WordPress setup has already been run, skipping..."
fi

exec /usr/sbin/php-fpm7.4 -F

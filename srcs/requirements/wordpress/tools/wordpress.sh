#!/bin/bash

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

    wp core install --url="rbroque.42.fr" --title="Ooooh very googoo gaga" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
    
    wp config set WP_REDIS_HOST redis --allow-root
  	wp config set WP_REDIS_PORT 6379 --raw --allow-root
  	wp config set ALLOW_UNFILTERED_UPLOADS true --raw --allow-root

    wp user create $WP_SUBSCRIBER_USER $WP_SUBSCRIBER_EMAIL --role=subscriber --user_pass=$WP_SUBSCRIBER_PASSWORD --allow-root
    wp theme install twentyseventeen --activate --allow-root
    wp post delete $(wp post list --format=ids --allow-root) --allow-root
    wp post create --post_type=post --post_title="Hello Inception!" --post_content="lol" --post_status=publish --allow-root
    wp media import /42logo.png --porcelain --allow-root | wp option update site_icon --allow-root

    # wp plugin install redis-cache --activate --allow-root
    wp redis enable --force --allow-root --path=/var/www/html

    echo "WordPress setup completed."

    touch $lock_file
else
    echo "WordPress setup has already been run, skipping..."
fi

exec php7.4-fpm -F
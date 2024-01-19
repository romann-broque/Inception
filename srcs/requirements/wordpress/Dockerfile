FROM debian:bullseye

# Update the package repository and install wordpress
RUN apt-get update && apt-get install -y curl php7.4-fpm php7.4-mysql mariadb-client php7.4-gd
RUN	apt-get install net-tools -y
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Expose port 9000 for php traffic
EXPOSE 9000

# Copy the Wordpress configuration
RUN mkdir -p /run/php
RUN mkdir -p /var/www/html/
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy entrypoint script
COPY tools/wordpress.sh /wordpress.sh
RUN chmod +x /wordpress.sh

# Set entrypoint
ENTRYPOINT ["/wordpress.sh"]

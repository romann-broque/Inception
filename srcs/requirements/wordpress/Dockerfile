# FROM debian:bullseye

# # Update and Install php dependencies and mariadb-client
# RUN apt-get update && apt-get upgrade -y

# RUN	apt-get install -y wget \
# 	# php-fpm7.3 \
# 	# php-fpm \
# 	php-mysql \
# 	php-mbstring \
# 	php-gd \
# 	php-xml \
# 	php-curl \
# 	php-zip \
# 	mariadb-client

# RUN apt-get install -y php7.4-fpm


# # Download wordpress file
# RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

# # Untar wordpress file
# RUN cd /var/www && \
# 	tar -xzf wordpress-6.0-fr_FR.tar.gz && \
# 	rm wordpress-6.0-fr_FR.tar.gz

# # Grant permissions for the wordpress folde
# RUN	chown -R root:root /var/www/wordpress

# # Setup the working directory
# WORKDIR /var/www/html

# # Expose port 9000 for PHP-FPM
# EXPOSE 9000

# RUN which php7.4-fpm

# # Define the entry point command to start PHP-FPM
# # CMD ["php-fpm", "--nodaemonize"]
# CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize"]

FROM debian:bullseye

RUN apt-get update && apt-get install -y curl php7.4-fpm php7.4-mysql mariadb-client php-redis php7.4-gd php-imagick
RUN mkdir -p /run/php
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

# COPY files/42logo.png /42logo.png
RUN mkdir -p /var/www/html/
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wordpress.sh /wordpress.sh
RUN chmod +x /wordpress.sh
ENTRYPOINT ["/wordpress.sh"]

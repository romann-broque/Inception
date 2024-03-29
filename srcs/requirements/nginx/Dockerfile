FROM debian:bullseye

# Update the package repository and install NGINX
RUN apt-get update && apt-get upgrade && \
	apt-get install nginx openssl -y

# SSL generation
RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=rbroque.42.fr/UID=rbroque"

# Set the working directory inside the container
WORKDIR /etc/nginx

# Copy the NGINX configuration
COPY ./conf/nginx.conf /etc/nginx/
RUN chown -R www-data:www-data /var/www/html

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Copy entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

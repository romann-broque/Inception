# Use the official NGINX image as the base image
FROM debian:bullseye

# Update the package repository and install NGINX
RUN apt-get update && \
	apt-get install nginx -y
RUN apt-get install openssl -y

# SSL generation

RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=login.42.fr/UID=login"

# Set the working directory inside the container
WORKDIR /etc/nginx

# Copy the NGINX configuration
COPY ./conf/nginx.conf /etc/nginx/
COPY ./tools/index.html /usr/share/nginx/html/index.html

# Expose ports 80 and 443 for HTTP and HTTPS traffic
EXPOSE 80
EXPOSE 443

# Define the entry point command to start NGINX
CMD ["nginx", "-g", "daemon off;"]

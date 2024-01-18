#!/bin/bash

# Wait for Wordpress
echo "Waiting for Wordpress"

# Substitute environment variables in the NGINX configuration file
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.cnf.template > /etc/nginx/nginx.conf

# Start NGINX
echo "Start Nginx"
nginx -g 'daemon off;'

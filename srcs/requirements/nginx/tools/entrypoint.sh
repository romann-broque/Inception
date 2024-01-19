#!/bin/bash
echo "Waiting for Wordpress..."
sleep 10

# Start NGINX

echo "Nginx starts"
nginx -g 'daemon off;'

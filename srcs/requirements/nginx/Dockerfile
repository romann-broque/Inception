# Use the official NGINX image as the base image
FROM nginx:1.21.4

# Set the working directory inside the container
WORKDIR /etc/nginx

# Copy the NGINX configuration, SSL certificate, and key into the container
COPY ./conf/ /etc/nginx/
COPY ./tools/index.html /usr/share/nginx/html/index.html

# Expose ports 80 and 443 for HTTP and HTTPS traffic
EXPOSE 80
EXPOSE 443

# Define the entry point command to start NGINX
CMD ["nginx", "-g", "daemon off;"]
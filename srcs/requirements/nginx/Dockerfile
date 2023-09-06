# Use the official NGINX image as the base image
FROM nginx:latest

# Set the working directory inside the container
WORKDIR /etc/nginx

# Copy all files from the local 'conf' folder into the container's '/etc/nginx' directory
COPY ./conf/ /etc/nginx/

# Expose ports 80 and 443 for HTTP and HTTPS traffic
EXPOSE 80
EXPOSE 443

# Define the entry point command to start NGINX
CMD ["nginx", "-g", "daemon off;"]
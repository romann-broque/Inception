# Use an official WordPress image as the base image
FROM wordpress:latest

# Install additional PHP extensions if needed
# RUN docker-php-ext-install extension_name

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Define the entry point command to start PHP-FPM
CMD ["php-fpm"]
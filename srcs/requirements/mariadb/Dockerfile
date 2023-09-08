# Use a base image (e.g., a specific Linux distribution) as your starting point
FROM ubuntu:20.04

# Set environment variables for MariaDB configuration
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_USER=db_user
ENV MYSQL_PASSWORD=db_password
ENV MYSQL_DATABASE=db_name

# Install MariaDB server and client
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy custom MariaDB configuration files (if needed)
# COPY my.cnf /etc/mysql/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Start the MariaDB server on container startup
CMD ["mysqld"]
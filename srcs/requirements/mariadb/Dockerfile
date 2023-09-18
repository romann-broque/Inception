FROM debian:bullseye

# Install MariaDB server and client
RUN apt-get update && \
    apt-get install mariadb-server mariadb-client -y

RUN mkdir -p /var/lib/mysql/

# Expose the default MariaDB port
EXPOSE 3306

# Set the working directory inside the container
WORKDIR /etc/mysql/

# Copy the MariaDB configuration
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the init DB script
COPY /tools/init_db.sh /etc/mysql/

# Grant execute permissions to the init DB script & Execute it
# RUN chmod +x /etc/mysql/init_db.sh

# RUN /etc/mysql/init_db.sh

# Start the MariaDB server on container startup
CMD ["mysqld"]


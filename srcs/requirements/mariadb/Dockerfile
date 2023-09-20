FROM debian:bullseye

# Install MariaDB server and client
RUN apt-get update && \
    apt-get install mariadb-server mariadb-client -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

# Expose the default MariaDB port
EXPOSE 3306

# Set the working directory inside the container
WORKDIR /etc/mysql/

# Copy the MariaDB configuration
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Copy the init DB script
COPY /tools/init_db.sh /etc/mysql/

# Grant execute permissions to the init DB script & Execute it
RUN chmod +x /etc/mysql/init_db.sh

RUN /etc/mysql/init_db.sh

# Start the MariaDB server on container startup
CMD ["mysqld_safe"]


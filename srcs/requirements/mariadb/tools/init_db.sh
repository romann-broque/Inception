#!/bin/sh

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
mkdir -p /run/mysqld

# Initialize the database if it doesn't exist
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Database already exists"
else
	# Create the database and set up permissions
	tfile="$(mktemp)"
	if [ ! -f "$tfile" ]; then
		return 1
	fi
	echo "USE mysql;" >> "$tfile"
	echo "FLUSH PRIVILEGES ;" >> "$tfile"
	echo "GRANT ALL ON *.* TO 'root'@'%' identified by ""$MYSQL_ROOT_PASSWORD"" WITH GRANT OPTION ;" >> "$tfile"
	echo "GRANT ALL ON *.* TO 'root'@'localhost' identified by ""$MYSQL_ROOT_PASSWORD"" WITH GRANT OPTION ;" >> "$tfile"
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ""$MYSQL_ROOT_PASSWORD"";" >> "$tfile"
	echo "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;" >> "$tfile"
	echo "FLUSH PRIVILEGES ;" >> "$tfile"
	echo "DROP DATABASE IF EXISTS test ;" >> "$tfile"
	echo "FLUSH PRIVILEGES ;" >> "$tfile"
	echo "CREATE DATABASE IF NOT EXISTS ""$MYSQL_DATABASE"" CHARACTER SET utf8 COLLATE utf8_general_ci;" >> "$tfile"
	echo "GRANT ALL ON ""$MYSQL_DATABASE"".* to '$MYSQL_USER'@'%' IDENTIFIED BY ""$MYSQL_USER_PASSWORD"";" >> "$tfile"
	echo "GRANT ALL PRIVILEGES ON ""$MYSQL_DATABASE"".* TO ""$MYSQL_USER'@'%"" IDENTIFIED BY ""$MYSQL_PASSWORD"";" >> "$tfile"
	echo "FLUSH PRIVILEGES" >> "$tfile";
	/usr/sbin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$tfile"
	echo $(cat $tfile)
	rm -f "$tfile"
fi


# Keep the MariaDB server running in the foreground
exec /usr/sbin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@


#!/bin/sh

MYSQL_DATABASE=wordpress

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Store commands into a temporary file
if [ -d /var/lib/mysql/$MYSQL_DATABASE ]; then
	echo "MySQL directory already present, skipping creation"
else
	echo "Creating database"
	mysql_install_db
	tfile="$(mktemp)"
	if [ ! -f "$tfile" ]; then
		return 1
	fi
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

	# Initialize mysqld
	/usr/sbin/mysqld --user=mysql --bootstrap --verbose --skip-name-resolve --skip-networking=0 < "$tfile"
	cat $tfile
	rm -f "$tfile"
fi

# Keep the MariaDB server running in the foreground
exec /usr/sbin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@


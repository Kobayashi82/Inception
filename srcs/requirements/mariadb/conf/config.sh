#!/bin/bash

set -e

# Check if WordPress database exists
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then

	# Initialization file
	cat << EOF > create_db.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
ALTER DATABASE ${SQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	# Execute initialization file
	mysqld --user=mysql --bootstrap < create_db.sql

	chown -R www-data /var/lib/mysql
	chmod -R 777 /var/lib/mysql

	# Check if initialization failed
	if [ $? -ne 0 ]; then echo "Failed to initialize database"; exit 1; fi
	echo "Database and user created successfully"
fi

chown -R www-data /var/lib/mysql
chmod -R 777 /var/lib/mysql

# Execute MariaDB
exec mysqld --bind-address=0.0.0.0

#!/bin/bash

set -e

timeout=30
elapsed=0

until mysqladmin ping -h mariadb -P 3306 --silent; do
	sleep 2
	elapsed=$((elapsed + 2))
    if [ "$elapsed" -ge "$timeout" ]; then exit 1; fi
done

if [ ! -f "/var/www/wp-config.php" ]; then
    wp core download --allow-root --path='/var/www'
    wp config create --allow-root \
                     --dbname=$SQL_DATABASE \
                     --dbuser=$SQL_USER \
                     --dbpass=$SQL_PASSWORD \
                     --dbhost=mariadb:3306 --path='/var/www'

    wp core install --allow-root \
                    --url=$WP_URL \
                    --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL --path='/var/www'
    
    wp user create --allow-root \
                   $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --path='/var/www'

    wp config set WP_REDIS_HOST 'redis' --allow-root --path='/var/www'
    wp config set WP_REDIS_PORT 6379 --raw --allow-root --path='/var/www'
    wp config set WP_REDIS_DISABLED false --raw --allow-root --path='/var/www'
    wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --allow-root --path='/var/www'

    wp plugin install redis-cache --activate --allow-root --path='/var/www'
    wp redis enable --allow-root --path='/var/www'
    
    wp theme install inspire --activate --allow-root
fi

chown -R www-data /var/www
chmod -R 777 /var/www

exec /usr/sbin/php-fpm7.4 -F

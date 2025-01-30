# Debian image
FROM debian:bullseye

# Install PHP & wget
RUN apt-get update && apt-get install -y wget php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-xml php7.4-curl php7.4-zip php7.4-mbstring php-redis mariadb-client

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# PHP Settings
RUN mkdir -p /run/php/
RUN sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 9000|g"	/etc/php/7.4/fpm/pool.d/www.conf

# WordPress Settings
RUN mkdir -p /var/www
WORKDIR /var/www
RUN mkdir -p /var/www/wp-content/uploads
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Copy config script
COPY conf/config.sh /usr/local/bin/config_wp.sh
RUN chmod +x /usr/local/bin/config_wp.sh

# Execute config script
ENTRYPOINT ["/usr/local/bin/config_wp.sh"]

EXPOSE 9000

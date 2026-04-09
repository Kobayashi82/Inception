# Debian image
FROM debian:bookworm

# Install PHP & wget
RUN apt-get update && apt-get install -y wget php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-curl php8.2-zip php8.2-mbstring php-redis mariadb-client

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# PHP Settings
RUN mkdir -p /run/php/
RUN sed -i "s|listen = /run/php/php8.2-fpm.sock|listen = 9000|g" /etc/php/8.2/fpm/pool.d/www.conf

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

# docker compose -f srcs/docker-compose.yml up -d --build --force-recreate wordpress nginx

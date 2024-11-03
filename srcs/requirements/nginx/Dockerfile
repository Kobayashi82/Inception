# Debian image
FROM debian:bullseye

# Install Nginx
RUN apt-get update && apt-get install -y nginx openssl curl

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Generate a self-signed SSL certificate and key
RUN mkdir -p /etc/nginx/ssl /usr/share
RUN openssl req -x509 -nodes -days 42 -newkey rsa:2048 \
	-out	/etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=ES/ST=Andalucia/L=Malaga/O=42 Malaga/OU=42/CN=inception"

# Copy config file, favicon.ico, index.html & the web site
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/favicon.ico /usr/share/favicon.ico
COPY conf/index.html /usr/share/index.html
COPY conf/inception /usr/share/inception

# Create start script
RUN printf "#!/bin/bash\n\
			mkdir -p /var/www/inception\n\
			if [ -f /usr/share/favicon.ico ]; then\n\
			    cp /usr/share/favicon.ico /var/www/favicon.ico\n\
			fi\n\
			if [ -f /usr/share/index.html ]; then\n\
				cp /usr/share/index.html /var/www/index.html\n\
			fi\n\
			if [ -d /usr/share/inception ]; then\n\
				cp -r /usr/share/inception /var/www\n\
			fi\n\
			chown -R www-data /var/www\n\
			chmod -R 777 /var/www\n\
			exec nginx -g \"daemon off;\"" > /start.sh
RUN chmod +x /start.sh

# Execute config script
ENTRYPOINT ["/start.sh"]

EXPOSE 443

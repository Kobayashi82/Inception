# Debian image
FROM debian:bullseye

# Install Nginx
RUN apt-get update && apt-get install -y vsftpd

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Vsftpd Settings
ARG FTP_USER FTP_PASS FTP_HOST
RUN mkdir -p  /var/run/vsftpd/empty
RUN chmod 555 /var/run/vsftpd/empty

# Create user
RUN useradd -m -d /var/www "$FTP_USER" && echo "$FTP_USER:$FTP_PASS" | chpasswd
RUN usermod -aG www-data "$FTP_USER"

# Create config file
RUN printf "listen=YES\n\
			local_enable=YES\n\
			local_umask=022\n\
			write_enable=YES\n\
			pasv_enable=YES\n\
			pasv_min_port=30000\n\
			pasv_max_port=30009\n\
			pasv_address=$FTP_HOST\n\
			anonymous_enable=NO\n\
			chroot_local_user=YES\n\
			allow_writeable_chroot=YES\n\
			secure_chroot_dir=/var/run/vsftpd/empty\n" > /etc/vsftpd.conf

# Create start script
RUN printf "#!/bin/bash\n\
			chown -R www-data /var/www\n\
			chmod -R 777 /var/www\n\
			/usr/sbin/vsftpd /etc/vsftpd.conf\n" > /start.sh
RUN chmod +x /start.sh

# Execute start script
ENTRYPOINT ["/start.sh"]

EXPOSE 21 30000-30009

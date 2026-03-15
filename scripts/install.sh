#!/bin/bash

apt-get update

# Install curl
if ! command -v curl &> /dev/null; then
	apt-get install -y curl
fi

# Install docker
if ! command -v docker &> /dev/null; then
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /usr/share/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    usermod -aG docker vagrant
    systemctl enable docker
    systemctl start docker
fi

# Install make
if ! command -v make &> /dev/null; then
	apt-get install -y make
fi

# Install X11 and browser
apt-get install -y xauth xorg firefox-esr filezilla

# Create user
if ! id "vzurera" &> /dev/null; then
	useradd -m -s /bin/bash vzurera
	echo "vzurera:aA123456789*" | chpasswd
fi

usermod -aG sudo vzurera
usermod -aG docker vzurera

# Hosts
if ! grep -q "vzurera.42.fr" /etc/hosts; then
	echo "127.0.0.1  vzurera.42.fr" >> /etc/hosts
fi

# Copy files
cp -r /tmp/srcs /home/vzurera
cp /tmp/Makefile /home/vzurera/Makefile
chown -R vzurera:vzurera /home/vzurera/srcs
chown vzurera:vzurera /home/vzurera/Makefile

# vagrant ssh -- -X -t "firefox"
# vagrant ssh -- -X -t "filezilla"

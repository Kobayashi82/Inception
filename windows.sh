#!/bin/bash

export DISPLAY=$(ip route | grep default | awk '{print $3}'):0

# Fix NAT rule
/mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe controlvm vzurera-S natpf1 delete ssh
/mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe controlvm vzurera-S natpf1 "ssh,tcp,0.0.0.0,2222,,22"

# Fix key permissions
cp ".vagrant/machines/vzurera-S/virtualbox/private_key" ~/.ssh/vzurera_key
chmod 600 ~/.ssh/vzurera_key

# Clean known hosts
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[172.31.176.1]:2222" 2>/dev/null

# Open browser and filezilla
WINDOWS_IP=$(ip route | grep default | awk '{print $3}')
ssh -Y -C -i ~/.ssh/vzurera_key -p 2222 -o StrictHostKeyChecking=no vagrant@$WINDOWS_IP 'firefox-esr https://vzurera.42.fr/inception & filezilla &'

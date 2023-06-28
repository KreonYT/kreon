#!/bin/bash

apt update -y
apt install vim network-manager nginx cifs-utils ca-certificates curl -y

echo "ssh"
sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
ssh-keygen


echo "SSH KEYS!!!!!"

echo "NFS"
mkdir /opt/nfs/

echo "/usr/share/ca-certificates/"

echo "Welcome to Server-1 Site-1" > /opt/nfs/site1/index1.html
echo "Welcome to Server-1 Site-2" > /opt/nfs/site2/index1.html
echo "Welcome to Server-2 Site-1" > /opt/nfs/site1/index2.html
echo "Welcome to Server-2 Site-2" > /opt/nfs/site2/index2.html
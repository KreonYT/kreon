#!/bin/bash

apt update -y
apt-get install vim nginx network-manager samba curl -y

echo "Samba"
mkdir /opt/nfs/site{1,2} -p
systemctl enable smb --now
echo "" >> /etc/samba/smb.conf

echo "Welcome to Server-1 Site-1" > /opt/nfs/site1/index1.html
echo "Welcome to Server-1 Site-2" > /opt/nfs/site2/index1.html
echo "Welcome to Server-2 Site-1" > /opt/nfs/site1/index2.html
echo "Welcome to Server-2 Site-2" > /opt/nfs/site2/index2.html
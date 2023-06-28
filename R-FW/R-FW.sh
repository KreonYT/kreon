#!/bin/bash

echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p

apt update -y
apt-get install vim nginx network-manager iptables-persistent curl -y

echo "OpenSSL"
mkdir ~/ca && cd ~/ca
echo "rootCA.key"
openssl req -newkey rsa:2048 -nodes -keyout ca.key -x509 -days 3654 -out ca.crt
echo "www.skill.wsr."
openssl req -newkey rsa:2048 -nodes -keyout www.key -out www.csr
openssl req -newkey rsa:2048 -nodes -keyout site1.key -out site1.csr
echo "www.skill.wsr.crt; READY!?"
openssl x509 -req -in www.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out www.crt -days 3652
openssl x509 -req -in site2.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out site2.crt -days 3652

echo "Firewall...."
iptables -t nat -A POSTROUTING -o eth0 -s 172.16.2.0/24 -j MASQUERADE
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 5000 -j DNAT --to-destination 172.16.2.25:22

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth1 -j ACCEPT
iptables -A INPUT -i gre1 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
iptables -P INPUT DROP

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -P FORWARD DROP

echo "/usr/local/share/ca-certificates/"
echo "update-ca-certificates -v"





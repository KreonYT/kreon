#!/bin/bash

#nmcli con del id eth0 
#nmcli con add con-name eth0 ifname eth0 autoconnect yes type ethernet ip4 "10.1.1.6/30" gw4 10.1.1.5
#nmcli con mod eth0 +ipv4.dns 8.8.8.8 +ipv4.dns 172.16.1.254 +ipv4.dns-search "skill.wsr"

#nmcli con del id eth1
#nmcli con add con-name eth1 ifname eth1 autoconnect yes type ethernet ip4 "172.16.2.254/24"

echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p

yum install nano nginx NetworkManager-tui iptables ncurses -y

echo "OpenSSL"
mkdir ~/certs/
 mkdir ~/ca && cd ~/ca
echo "rootCA.key"
openssl req -newkey rsa:2048 -nodes -keyout ca.key -x509 -days 3654 -out ca.crt
echo "rootCA.crt"
openssl x509 -req -in ~/certs/domain.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out domain.crt -days 365
echo "www.skill.wsr."
openssl req -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr
echo "www.skill.wsr.crt; READY!?"
openssl x509 -req -in www.skill.wsr.csr -CA CA.crt -CAkey CA.key -CAcreateserial -out www.skill.wsr.crt -days 3650 -sha256


echo "frr"
systemctl stop frr
sed -ie 's/ospfd=no/ospfd=yes/' /etc/frr/daemons
sed -ie 's/zebra=no/zebra=yes/' /etc/frr/daemons
systemctl enable --now frr

echo "Firewall...."
iptables -t nat -A POSTROUTING -o eth0 -s 172.16.2.0/24 -j MASQUERADE
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 5000 -j DNAT --to-destination 172.16.2.25:22

iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED, RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
iptables -A INPUT -i eth1 -J ACCEPT
iptables -A INPUT -i gre1 -J ACCEPT
iptables -A INPUT -i lo -J ACCEPT

iptables -P INPUT ACCEPT


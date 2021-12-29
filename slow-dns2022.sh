#!/bin/bash

#atur DNS domain
#A	tns.example.com	points to 203.0.113.2
#AAAA	tns.example.com	points to 2001:db8::2
#NS	t.example.com	is managed by tns.example.com

#installer SLow DNS

#setting iptables ipv4
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -i eth0 -p udp --dport 53 -j REDIRECT --to-ports 5300
iptables -t nat -A POSTROUTING -j MASQUERADE

#setting iptables ipv6
sudo ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
sudo ip6tables -t nat -I PREROUTING -i eth0 -p udp --dport 53 -j REDIRECT --to-ports 5300

#save iptables
netfilter-persistent save
netfilter-persistent reload


#install golang
apt-get install golang -y

#download scource slowdns
wget https://github.com/Mygod/dnstt/archive/refs/heads/plugin.zip
unzip plugin.zip
cd 

cd dnstt/dnstt-server
go build
./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub

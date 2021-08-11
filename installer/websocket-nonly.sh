#!/bin/bash
#websocket Dropbear and OpenVPN

#websocket Dropbear 69 to 8880
wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/4hidessh/cuy1/main/websocket-python/ws-dropbear && chmod +x /etc/systemd/system/ws-dropbear.service
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/4hidessh/cuy1/main/websocket-python/ws-dropbear.service && chmod +x /usr/local/bin/ws-dropbear

systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service

##System Websocket-OpenVPN Python 1194 to 2086
wget -O /etc/systemd/system/ws-ovpn.service https://raw.githubusercontent.com/4hidessh/cuy1/main/websocket-python/ws-ovpn && chmod +x /etc/systemd/system/ws-ovpn.service
wget -O /usr/local/bin/ws-openvpn https://raw.githubusercontent.com/4hidessh/cuy1/main/websocket-python/ws-ovpn.service && chmod +x /usr/local/bin/ws-ws-openvpn

systemctl daemon-reload
systemctl enable ws-ovpn.service
systemctl start ws-ovpn.service
systemctl restart ws-ovpn.service

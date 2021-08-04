#!/bin/bash
#installer SSH + Webcocket dan VPN  Bye HideSSH.com
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);

if [ -f "/etc/v2ray/domain" ]; then
echo "Script Already Installed"
exit 0
fi
mkdir /var/lib/premium-script;
echo "IP=" >> /var/lib/premium-script/ipvps.conf


#install ssh ovpn
wget https://raw.githubusercontent.com/Alamyazid/rev/main/ssh.sh && chmod +x ssh.sh && screen -S ssh ./ssh.sh



rm -f /root/ssh.sh
rm -f /root/weleh.sh
rm -f /root/sstp.sh
rm -f /root/wg.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/ins-vt.sh
rm -f /root/ipsec.sh
rm -f /root/set-br.sh
rm -f /root/cf.sh
rm -f /root/websocket.sh
cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://hidessh.com

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://raw.githubusercontent.com/Alamyazid/rev/main/set.sh"
chmod +x /etc/set.sh
history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"

echo " Reboot 15 Sec"
sleep 15
rm -f setup.sh
reboot

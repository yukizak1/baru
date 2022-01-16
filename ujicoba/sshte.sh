#!/bin/bash
# created bye hidessh.com
# Auto installer SSH+ Full Websocket + VPN bye HideSSH
# port Stunnel and Websocket 443
#Selesai instalasi Websocket
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ifconfig.me/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/4hidessh/baru/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

#instalasi Websocket

# Websocket OpenSSH
#port 88 (OpenSSH) to 2082 (HTTP Websocket)
cd
wget -O /usr/local/bin/edu-proxy https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/http.py && chmod +x /usr/local/bin/edu-proxy
wget -O /etc/systemd/system/edu-proxy.service https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/http.service && chmod +x /etc/systemd/system/edu-proxy.service
systemctl daemon-reload.service
systemctl enable edu-proxy.service
systemctl restart edu-proxy.service
clear

# Dropbear WebSocket
#port 69 ( Dropbear) to 8880 (HTTPS Websocket)
cd
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/https.py && chmod +x /usr/local/bin/ws-dropbear
wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/https.service && chmod +x /etc/systemd/system/ws-dropbear.service
#reboot service
systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
clear

# OpenVPN WebSocket
#port 1194 ( Dropbear) to 2086 (HTTP Websocket)
wget -O /usr/local/bin/edu-proxyovpn https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/ovpn.py && chmod +x /usr/local/bin/edu-proxyovpn
wget -O /etc/systemd/system/edu-proxyovpn.service https://raw.githubusercontent.com/4hidessh/baru/main/websocket-python/baru/ovpn.service && chmod +x /etc/systemd/system/edu-proxyovpn.service
#reboot service
systemctl daemon-reload
systemctl enable edu-proxyovpn.service
systemctl start edu-proxyovpn.service
systemctl restart edu-proxyovpn.service
clear

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl
apt -y install python

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "neofetch" >> .profile
echo "echo by HideSSH.com" >> .profile
echo "echo Ketik menu" >> .profile

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/4hidessh/baru/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/4hidessh/baru/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/4hidessh/baru/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\chmod +x /etc/stunnel/hidessh.pem' /etc/rc.local
sed -i '$ i\chmod +x /etc/stunnel/stunnel.pem' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500


# setting port ssh
sed -i '/Port 22/a Port 88' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=44/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 69 -p 77 -p 300"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install stunnel
apt install stunnel4 -y

#certi stunnel
wget -O /etc/stunnel/hidessh.pem https://raw.githubusercontent.com/4hidessh/baru/main/certi/stunel && chmod +x /etc/stunnel/hidessh.pem


#konfigurasi stunnel4
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/hidessh.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 444
connect = 127.0.0.1:300

[dropbear]
accept = 777
connect = 127.0.0.1:77

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[slws]
accept = 8443
connect = 127.0.0.1:443

[sslws]
accept = 443
connect = 127.0.0.1:443

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

cd
#install sslh
apt-get install sslh -y

#konfigurasi
#port 333 to 44 and 777
wget -O /etc/default/sslh "https://raw.githubusercontent.com/4hidessh/baru/main/SSLH/sslh.conf"
service sslh restart


# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/4hidessh/hidessh/main/config/squid2"
sed -i $MYIP2 /etc/squid/squid.conf


#install badvpncdn
wget https://github.com/ambrop72/badvpn/archive/master.zip
unzip master.zip
cd badvpn-master
mkdir build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
sudo make install

END


# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

cd
# Delete Acount SSH Expired
echo "================  Auto deleted Account Expired ======================"
wget -O /usr/local/bin/userdelexpired "https://raw.githubusercontent.com/4hidessh/sshtunnel/master/userdelexpired" && chmod +x /usr/local/bin/userdelexpired

#OpenVPN
cd
#wget https://raw.githubusercontent.com/4hidessh/baru/main/vpnku.sh && chmod +x vpnku.sh && ./vpnku.sh
wget https://raw.githubusercontent.com/4hidessh/baru/main/vpn.sh && chmod +x vpn.sh && ./vpn.sh

# install python
apt -y install ruby
gem install lolcat
apt -y install figlet

# download script
cd /usr/bin
wget -O autoservice "https://raw.githubusercontent.com/4hidessh/baru/main/autodown.sh"
wget -O add-host "https://raw.githubusercontent.com/4hidessh/cuy1/main/tambah/addhost1.sh"
wget -O about "https://raw.githubusercontent.com/4hidessh/baru/main/about.sh"
wget -O menu "https://raw.githubusercontent.com/4hidessh/baru/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/4hidessh/baru/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/4hidessh/baru/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/4hidessh/baru/main/hapus.sh"
wget -O member "https://raw.githubusercontent.com/4hidessh/baru/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/4hidessh/baru/main/delete.sh"
wget -O cek "https://raw.githubusercontent.com/4hidessh/baru/main/cek.sh"
wget -O restart "https://raw.githubusercontent.com/4hidessh/baru/main/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/4hidessh/baru/main/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/4hidessh/baru/main/info.sh"
wget -O ram "https://raw.githubusercontent.com/4hidessh/baru/main/ram.sh"
wget -O renew "https://raw.githubusercontent.com/4hidessh/baru/main/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/4hidessh/baru/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/4hidessh/baru/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/4hidessh/baru/main/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/4hidessh/baru/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/4hidessh/baru/main/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/4hidessh/baru/main/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/4hidessh/baru/main/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/4hidessh/baru/main/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/4hidessh/baru/main/port-tr.sh"
wget -O port-sstp "https://raw.githubusercontent.com/4hidessh/baru/main/port-sstp.sh"
wget -O port-squid "https://raw.githubusercontent.com/4hidessh/baru/main/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/4hidessh/baru/main/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/4hidessh/baru/main/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/4hidessh/baru/main/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/4hidessh/baru/main/xp.sh"
wget -O update "https://raw.githubusercontent.com/4hidessh/baru/main/update.sh"
wget -O user-limit "https://raw.githubusercontent.com/4hidessh/baru/main/user-limit.sh"  
wget -O cfd "https://raw.githubusercontent.com/4hidessh/baru/main/cfd.sh"
wget -O cff "https://raw.githubusercontent.com/4hidessh/baru/main/cff.sh"
wget -O cfh "https://raw.githubusercontent.com/4hidessh/baru/main/cfh.sh"
wget -O autoreboot "https://raw.githubusercontent.com/4hidessh/baru/main/allservice.sh"

chmod +x add-host
chmod +x autoservice
chmod +x user-limit
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-sstp
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x xp
chmod +x update
chmod +x cfd
chmod +x cff
chmod +x cfh
chmod +x autoreboot

#cronjob
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 17 * * * root clear-log && reboot" >> /etc/crontab
echo "50 * * * * root userdelexpired" >> /etc/crontab
echo "5 * * * * root autoservice" >> /etc/crontab


# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y



# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid restart

screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500

history -c
echo "unset HISTFILE" >> /etc/profile

#hapus file instalasi
cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/ihide
rm -rf /root/vpnku.sh


apt install dnsutils jq -y
apt install net-tools -y
apt install tcpdump -y
apt install dsniff -y
apt install grepcidr -y

# finihsing
clear
reboot

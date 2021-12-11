#!/bin/bash
sstat=dead
for serv in stunnel4 dropbear squid openvpn sslh
do
systemctl status $serv | grep -i 'running\|dead' | awk '{print $3}' | sed 's/[()]//g' | while read output;
do
echo $output
if [ "$output" == "$sstat" ]; then
    systemctl start $serv
    service restart $serv
    echo "$serv service is UP now.!" | mail -s "$serv service is DOWN and restarted now On $(hostname)" 4rukadi@gmail.com
    else
    echo "$serv service is running"
    fi
done
done

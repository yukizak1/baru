#!/bin/bash
#Scripts to start services if not running
ps -ef | grep dropbear |grep -v grep > /dev/null
if [ $? != 0 ]
then
       /etc/init.d/dropbear start > /dev/null
       /etc/init.d/dropbear restart > /dev/null
fi
ps -ef | grep stunnel4 |grep -v grep > /dev/null
if [ $? != 0 ]
then
       /etc/init.d/stunnel4 start > /dev/null    
       /etc/init.d/stunnel4 restart > /dev/null
fi
ps -ef | grep openvpn |grep -v grep > /dev/null
if [ $? != 0 ]
then
       /etc/init.d/openvpn start > /dev/null 
       /etc/init.d/openvpn restart > /dev/null
fi
ps -ef | grep sslh |grep -v grep > /dev/null
if [ $? != 0 ]
then
       /etc/init.d/sslh start > /dev/null    
       /etc/init.d/sslh restart > /dev/null
fi

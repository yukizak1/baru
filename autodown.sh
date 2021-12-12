#!/bin/bash

service dropbear status | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        sudo service dropbear restart > /dev/null
fi

service stunnel4 status | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        sudo service stunnel4 restart > /dev/null
fi

service openvpn status | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        sudo service openvpn restart > /dev/null
fi

service sslh status | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        sudo service sslh restart > /dev/null
fi


service squid status | grep 'active (running)' > /dev/null 2>&1

if [ $? != 0 ]
then
        sudo service squid restart > /dev/null
fi

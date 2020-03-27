#!/bin/bash

#this deletes all wifi network connections. 
#run at shutdown
#fixes a vulnerabilty that can be exploited by the WIFIpineapple to spoof 
#known connections and intercept traffic

#make a backup of /etc/Network/manager/system-connections
#cp /etc/NetworkManager/system-connections/* /etc/NetworkManager/bak/


sudo rm /etc/NetworkManager/system-connections/*

$sudo cp /etc/NetworkManager/bak/* /etc/NetworkManager/system-connections/


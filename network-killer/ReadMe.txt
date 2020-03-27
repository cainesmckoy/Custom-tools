this deletes all wifi network connections. 
run at shutdown
fixes a vulnerabilty that can be exploited by the WIFI pineapple and other wifi hacking tools to spoof known connections and intercept traffic

make a backup of /etc/Network/manager/system-connections

cp /etc/NetworkManager/system-connections/* /etc/NetworkManager/bak/


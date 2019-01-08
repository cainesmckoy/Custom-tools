#!/bin/bash
#set up DNS with nothing but this script 
#tons of fukin promts and variables
#V1.0 functions to create primary server on linux
#tested on ubuntu 16.04
DEFAULT=default 

function startup {
    service="bind9"
    variables=${1-DEFAULT};
    serv="service $service status ";
    $serv  > fuckshit.txt ;
    stat="grep dead fuckshit.txt";
    $stat;
    match="grep --only-matching dead fuckshit.txt";
   
    if [[ "$match"=="true" ]]
    then
        service $service start
        sleep 1
        service $service status
    fi;

}

startup



function makefiles {
#FILE="/path/to/file/to/auto/make"
FILE="/etc/bind/db.f";
FILE2="/etc/bind/db.r";


read -p 'what is YOUR hostname?' host;
read -p 'what is your DOMAIN?' domain;
read -p 'what is your IP ADDR' ip;
#read -p 'what is the Primary DNS HOSTNAME?' host2
#read -p 'what is the Primary DNS IP' ip2

last=${ip%:}
last=${last##*.}
#echo $last  cuts the string of the ip to the last octet

revip=$(printf "$ip" | awk -F '.' '{print $3,$2,$1}' OFS='.')

cd /etc/bind/;
function forward { 
printf ""'$TTL'" 604800
@       IN      SOA     $host.$domain   root.$domain (
        101010 ;serial
        36000  ;refresh
        1800   ;retry
        604800 ;expire
        86400  ;minimum TTL
)
@       IN      NS      $host.$domain.
$host  IN      A       $ip" > db.f;
}
forward

function reverse {
printf ""'$TTL'" 604800
@       IN      SOA     $host.$domain.   root.$domain. (
        101010 ;serial
        36000  ;refresh
        1800   ;retry
        604800 ;expire
        86400  ;minimum TTL
)
@       IN      NS      $host.$domain.
$host  IN      A       $ip
    $last   IN      PTR     $host.$domain." > db.r;
}

reverse

function namedconf {
    echo "Zone “$domain” {
	Type master;
    File "\"$FILE\"";
	Allow-transfer {$ip;};
	Also-notify {$ip;};
};
Zone “$revip.in-addr.arpa” {
	Type master;
	File "\"$FILE2\"";
	Allow-transfer {$ip;};
	Also-notify {$ip;};
};
logging {
    channel query.log {
        file "\"/var/lib/bind/query.log"\";

        severity debug 3;
    };
    category queries { query.log; };
};" > /etc/bind/named.conf.local;
}
namedconf

function option { echo "
    acl $host {
        $ip;

    };

    options {
        directory "\"/var/cache/bind\"";
        check-names master ignore;      
        recursion yes;
        allow-query { $host; };
        forwarders {
            8.8.8.8;
            8.8.4.4;
        };
        forward only;    
        dnssec-validation yes;

        auth-nxdomain no;   
        listen-on-v6 { none; };
    };" > /etc/bind/named.conf.options;
}
options

chown root:bind db.f;
chown root:bind db.r;
chown root:bind named.conf.local;
chown root:bind named.conf.options;
sleep 10;
service bind9 restart;
sleep 1;
service bind9 status;

}
makefiles
#cat /etc/bind/named.conf.local
#startup

#exit

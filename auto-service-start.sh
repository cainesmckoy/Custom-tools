#!/bin/bash
#set up DNS with nothing but this script 
#tons of fukin promts and variables
#V1.2 update service is a variable that can be changed
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

exit

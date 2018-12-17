#!/bin/bash
#this is a sub-script to start up any Service
#caine munro
DEFAULT=default 

function startup {
    variables=${1-DEFAULT};
    serv="service bind9 status ";
    $serv  > fuckshit.txt ;
    stat="grep dead fuckshit.txt";
    $stat;
    match="grep --only-matching dead fuckshit.txt";
   
    if [[ "$match"=="true" ]]
    then
        service bind9 start
        sleep 1
        service bind9 status
    fi;

}
startup

exit


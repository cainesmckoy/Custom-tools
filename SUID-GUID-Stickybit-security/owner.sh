#!/bin/bash

set -x 

if [ -z /usr/bin/find ]
then 
    mv /usr/bin/find /usr/bin/fred
fi

fred /usr/*bin -type f \( -perm -4000 \) -exec ls {} \; > owner.txt

while read fName
do
    cp -p $fName .o
    chmod u-s $fName
done < owner.txt

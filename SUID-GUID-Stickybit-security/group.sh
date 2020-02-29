#!/bin/bash

set -x 

fred /usr/*bin -type f \( -perm -2000 \) -exec ls {} \; > group.txt

while read fName
do
    cp -p $fName .g/
    chmod g-s $fName
done < group.txt

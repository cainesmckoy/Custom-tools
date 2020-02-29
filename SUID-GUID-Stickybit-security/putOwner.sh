#!/bin/bash

set -x 

while read fName
do
    chmod u+s $fName
done < owner.txt

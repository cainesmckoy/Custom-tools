#!/bin/bash

while read fName
do
    chmod g+s $fName
done < group.txt

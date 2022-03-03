#!/usr/bin/bash

if [ $# -ne 1 ]; then
    echo "No valid IPv4 address passed."
    exit
fi

ip=$1
sum=0
for i in 1 2 3 4; do
    sum=$(( $sum * 256 + $(echo $ip | cut -d '.' -f $i) ))
done
echo $sum

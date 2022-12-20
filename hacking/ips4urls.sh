#!/usr/bin/bash
while read url; do
	host $url | sed -n -e 's/.* \([0-9\.]\{7,15\}\).*$/\1/p' >> ips_unsorted
done
sort -t . -g -k1,1 -k2,2 -k3,3 -k4,4 ips_unsorted | uniq
rm ips_unsorted

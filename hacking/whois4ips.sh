#!/usr/bin/bash

# useage:
# > cat ips.txt | ./whois4ips.sh
# > cat urls.txt | ./ips4urls.sh | ./whois4ips.sh

while read ip; do
	echo "\n# whois $ip";
	whois $ip | sed -n -e '/inet\|NetRange\|Role\|OrgName\|Organization\|descr/p'; # created\|last-modified\|RegDate\|Updated\|address\|
	echo "";
done

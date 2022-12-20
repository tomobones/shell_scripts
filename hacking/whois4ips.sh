#!/usr/bin/bash

while read ip; do
	echo "\n# whois $ip";
	whois $ip | sed -n -e '/inet\|NetRange\|Role\|OrgName\|Organization\|descr/p'; # created\|last-modified\|RegDate\|Updated\|address\|
	echo "";
done

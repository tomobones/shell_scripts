#!/usr/bin/bash
while read line; do
	echo $line | sed -n -e 's/Nmap scan report for.*[ \(]\([0-9\.]\{7,15\}\).*$/\n\1/p' -e '/^[0-9]*\/tcp open/p'
done

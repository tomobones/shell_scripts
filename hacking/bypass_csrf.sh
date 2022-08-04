#!/usr/bin/bash

#payload=$(/home/kali/urlencode.sh $1)
payload=$1
url0="https://0ac00080038c1ca7c04262b500b50091.web-security-academy.net"
url1="https://0ac00080038c1ca7c04262b500b50091.web-security-academy.net/post?postId=8"
url2="https://0ac00080038c1ca7c04262b500b50091.web-security-academy.net/post/comment"
session="oQPIySDzHVZ8FAm6MQJMY9Fs3G3kWz7p"

curl -s -c cookie.txt $url0 1>/dev/null

csrf=$(curl -s -b cookie.txt $url1 | sed -n 's/^.*csrf" value="\([0-9a-zA-Z]*\)".*/\1/p')

curl -s -b cookie.txt\
 -d "csrf=$csrf"\
 -d "postId=8"\
 -d "comment=$payload"\
 -d "name=$payload"\
 -d "email=test%40mail.net"\
 -d "website=https%3A%2F%2Fwww.test.net" $url2

rm cookie.txt

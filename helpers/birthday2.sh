#!/usr/bin/sh

n=${#1}
pad=$(printf "%${n}s")
str=''
for i in {1..4}
do
  str=$str"  \e[31;43;1m  Happy birthday "
  if [ $i -eq 3 ]
  then
    str=$str"Dear $1  \e[0m\n"
  else
    str=$str"to you ${pad}\e[0m\n"
  fi
done
echo -e "\n$str"

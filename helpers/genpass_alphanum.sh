#!/usr/bin/bash
if [ $# -eq 1 ] && [ $1 -gt 0 ] && [ $1 -lt 65 ];
then
    END=$1
else
    END=32
fi
cat /dev/urandom | tr -dc '0-9a-zA-Z' | fold -w ${1:-$END} | head -n 1

#!/usr/bin/bash
cat /dev/urandom | tr -dc '0-9a-zA-Z' | fold -w ${1:-32} | head -n 1

#!/usr/bin/bash
cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-32} | head -n 1

#!/usr/bin/bash
    
string=$1
printf '%b\n' "${string//%/\\x}"

#!/usr/bin/bash
while read string ; do
    printf '%b\n' "${string//%/\\x}"
done

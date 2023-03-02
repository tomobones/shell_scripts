#!/usr/bin/bash
old_lc_collate=$LC_COLLATE
LC_COLLATE=C
while read -n 1 c ; do
    [[ 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.~_-' =~ "$c" ]] && printf '%s' "$c" || printf '%%%02X' "'$c"
done
LC_COLLATE=$old_lc_collate

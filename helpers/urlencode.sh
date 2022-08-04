#!/usr/bin/bash
old_lc_collate=$LC_COLLATE
LC_COLLATE=C

length="${#1}"
for (( i = 0; i < length; i++ )); do
    c="${1:$i:1}"
    case $c in
        [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
        *) printf '%%%02X' "'$c" ;;
    esac
done
LC_COLLATE=$old_lc_collate

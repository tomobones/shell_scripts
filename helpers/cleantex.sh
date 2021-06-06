#!/usr/bin/bash

echo "cleaning .log .aux and .out files"
echo "---------------------------------"

if [ -z "$(ls *.log *.aux *.out 2>/dev/null)" ]; then
    echo "> nothing to clean"
    printf "\n"
    exit 0
fi
    
for file in $(ls *.log *.aux *.out)
do
    if test -f "$file"; then
        rm $file 2>/dev/null
        echo "> $file removed"
    fi
done

printf "\n"
exit 0

#!/usr/bin/bash

regex_code="(\s*)(/src/[a-zA-Z0-9_]*\.c)"
regex_img="(\s*)(/img/[a-zA-Z0-9_-]*\.png)"

IFS=$'\n' 
while read -u 0 line
do
	if [[ "$line" =~ $regex_code ]]
	then
		space="${BASH_REMATCH[1]}"
		file="${BASH_REMATCH[2]}"

		printf "%s%s\n" "$space" "~~~c"
		sed "s/^.*$/$space&/" ".$file"
		printf "%s%s\n" "$space" "~~~"
	elif [[ "$line" =~ $regex_img ]]
	then
		space="${BASH_REMATCH[1]}"
		file="${BASH_REMATCH[2]}"
		printf "%s![](.%s)\n" "$space" "$file"
	else
		printf "%s\n" "$line"
	fi
done

exit 0

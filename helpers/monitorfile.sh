#/usr/bin/bash
if [ -z "$(which inotifywait 2> /dev/null)" ];
then
    echo "install inotify"
else
    printf "monitoring file(s) %s\n" $1
    while inotifywait -q $1 >/dev/null
    do
       echo "trigger"
    done
fi

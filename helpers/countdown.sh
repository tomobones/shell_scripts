#!/usr/bin/bash

echo
for i in `seq 5 -1 0`
do
echo -n "...$i"
#play -q -n -t alsa synth 0.1 sin 280
sleep 1.0
done
echo

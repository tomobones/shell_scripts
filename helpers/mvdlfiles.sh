#!/usr/bin/bash
# export DIR=NoStarchPress_Hacking
mkdir ~/Documents/Books/New/$DIR && find ~/Downloads/ -type f -cmin -10 | xargs -I{} mv {} ~/Documents/Books/New/$DIR && ls $DIR | wc

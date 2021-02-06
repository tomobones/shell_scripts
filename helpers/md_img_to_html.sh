#!/bin/bash

sed "s_^/img/[0-9]\{2,3\}[a-z]\{0,1\}.png_\![](.&)_" $1 | pandoc -f markdown -t html -o index.html

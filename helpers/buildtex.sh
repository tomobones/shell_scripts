#!/usr/bin/bash
for file in $(ls *.tex); do pdflatex "$file" 1>/dev/null && echo "compiled $file"; done

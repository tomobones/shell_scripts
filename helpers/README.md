# Helpers - Shell Scripts

Some one-liners (or not much more than one line) for my dayly automated work.

- **imgcode2md.sh** includes code from files with reference patter '/src/example.c' and substitutes lines of pattern '/img/01.png' to '![](./img/01.png)'

- **md_img_to_html.sh** substitutes lines in markdown documents of the form `/img/01.png` to the form `![](./img/01.png)` and pipes the resulting markdown into `pandoc`, transforming it into an html document.

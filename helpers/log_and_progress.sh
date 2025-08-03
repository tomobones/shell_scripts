#!/bin/bash

COUNT=0
TOTAL=100
ENABLE_PROGRESSBAR="false"

function log_info() {
    log "\e[37m[+] $1\e[0m\n"
}

function log_warn() {
    log "\e[33m[!] $1\e[0m\n"
}

function log_error() {
    log "\e[31m[!] $1\e[0m\n"
}

function log_success() {
    log "\e[34m[+] $1\e[0m\n"
}

function log() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "$1"
        return
    fi
    tput rc
    tput el
    printf "$1"
    tput sc
    progress_increase
}

function progress_start() {
    COUNT=0
    PROGRESS_ENABLE="true"
    #tput clear #enable to start on the bottom
    tput civis
    trap 'progress_end; log_info "Script interrupted at iteration $COUNT from $TOTAL"; exit 1' SIGINT SIGTERM
}

function progress_increase() {
    let COUNT++
    cols=$(tput cols)
    label=$(printf "Progress: %d/%d " $COUNT $TOTAL)
    bar_width=$((cols - ${#label} - 1))  # 10 = Puffer für [ ] & Abstand
    bar_filled=$(printf "\e[34m%0.s█\e[0m" $(seq 1 $filled))
    bar_empty=$(printf "\e[30m%0.s█\e[0m" $(seq 1 $empty))
    if [ "$COUNT" -lt "$TOTAL" ]; then
        filled=$((COUNT * bar_width / TOTAL))
        empty=$((bar_width - filled))
        printf "%s%s%s" "$label" "$bar_filled" "$bar_empty"
    else
        filled=$bar_width
        printf "%s%s" "$label" "$bar_filled"
    fi
}

function progress_end() {
    tput rc
    tput el
    tput cnorm
    PROGRESS_ENABLE="false"
    trap - EXIT SIGINT SIGTERM
}

# example code
progress_start
log_info 'before start'
for ((i = 1; i <= TOTAL; i++)); do
    log_warn "Doing step $i"
    sleep 0.03
done
progress_end
log_success "Successfully fulfilled all $TOTAL iterations"

#!/bin/bash

COUNT=0
TOTAL=100
PROGRESS_ENABLE="false"

function logdate() {
    date "+%Y.%m.%d %H:%M:%S %3N"
}

function log_info() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[37m[+] %s %s\e[0m\n" "$(logdate)" "$1"
        return
    fi
    tput rc
    tput el
    printf "\e[37m[+] %s %s\e[0m\n" "$(logdate)" "$1"
    tput sc
    progress_increase
}

function log_warn() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[33m[+] %s %s\e[0m\n" "$(logdate)" "$1"
        return
    fi
    tput rc
    tput el
    printf "\e[33m[+] %s %s\e[0m\n" "$(logdate)" "$1"
    tput sc
    progress_increase
}

function log_error() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[31m[+] %s %s\e[0m\n" "$(logdate)" "$1"
        return
    fi
    tput rc
    tput el
    printf "\e[31m[+] %s %s\e[0m\n" "$(logdate)" "$1"
    tput sc
    progress_increase
}

function log_success() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[34m[+] %s %s\e[0m\n" "$(logdate)" "$1"
        return
    fi
    tput rc
    tput el
    printf "\e[34m[+] %s %s\e[0m\n" "$(logdate)" "$1"
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
    cols=$(tput cols)
    label=$(printf "Progress: %d/%d " $COUNT $TOTAL)
    bar_width=$((cols - ${#label} - 1))  # 10 = Puffer für [ ] & Abstand
    if [ "$COUNT" -lt "$TOTAL" ]; then
        filled=$((COUNT * bar_width / TOTAL))
        empty=$((bar_width - filled))
        bar_filled=$(printf "\e[34m%0.s█\e[0m" $(seq 1 $filled))
        bar_empty=$(printf "\e[30m%0.s█\e[0m" $(seq 1 $empty))
        printf "%s%s%s" "$label" "$bar_filled" "$bar_empty"
    else
        filled=$bar_width
        bar_filled=$(printf "\e[34m%0.s█\e[0m" $(seq 1 $filled))
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
log_success 'Starting Script'
for ((i = 1; i <= TOTAL; i++)); do
    let COUNT++
    log_info "Doing step $i"
    sleep 0.03
done
progress_end
log_success "Successfully fulfilled all $TOTAL iterations"

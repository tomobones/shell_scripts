#!/bin/bash

COUNT=0
TOTAL=100

function log_start() {
    tput clear
    tput civis
    printf "\n"
}

function log_info() {
    log "\e[37m[+] $1\e[0m\n"
}

function log_warn() {
    log "\e[33m[+] $1\e[0m\n"
}

function log_error() {
    log "\e[31m[+] $1\e[0m\n"
}

function log_success() {
    log "\e[34m[+] $1\e[0m\n"
}

function log() {
    tput rc
    tput el
    printf "$1"
    tput sc
    printf "\e[36mProgress: %d/%d\e[0m" "$COUNT" "$TOTAL"
}

function log_end() {
    tput rc
    printf "\n"
    tput cnorm
}

log_start
log_info 'before start'
for ((i = 1; i <= TOTAL; i++)); do
    let COUNT++
    log_warn "Doing step $i"
    sleep 0.03
done
log_success "Done"
log_end

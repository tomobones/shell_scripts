#!/usr/bin/bash

TAR_FILE=/home/thomas/backup_$(date +"%y%m%d_%H%M").tar.gz
APT_FILE=/home/thomas/apt_list.txt
VB_FILE="/home/thomas/VirtualBox VMs/"
SRC_PATHS="/home/thomas/bin /home/thomas/.bash_history /home/thomas/.gnupg /home/thomas/Backup /home/thomas/.ssh /home/thomas/.config /home/thomas/.vimrc /home/thomas/.bashrc /home/thomas/passwords.kdbx $APT_FILE"

printf "\n\e[34m%s\e[0m\n" "Host Backup Program"

if [[ "$#" == 0 ]]
then
    BCK_PATH=/media/thomas/Backup
    printf "Starting backup to device $BCK_PATH.\n"
elif [[ "$#" == 1 ]]
then
    BCK_PATH=$1
    printf "Starting backup to device $BCK_PATH.\n"
else
    printf "Please set no or one parameter.\n\n"
    exit 0
fi

if mount | cut -d " " -f 3 | grep $BCK_PATH > /dev/null
then
    printf "$BCK_PATH is mounted. Now choose your option...\n"
else
    printf "$BCK_PATH is not mounted. Exit.\n"
    exit 0
fi

# rsync

printf "\n\e[34m%s\e[0m " "Syncronizing home folder."
read -p "Want to sync (y/N): " query
if [[ "$query" =~ ^(y|Y|yes|YES|Yes) ]]
then
    # create apt_list.txt file
    comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) > $APT_FILE

    # create tar from src_paths
    printf "\nCreating tar from files in home folder...\n"
    tar cvzf "$TAR_FILE" $SRC_PATHS

    # rsync
    sudo rsync -vhuzP --remove-source-files "$TAR_FILE" "$BCK_PATH"/host_home

    # clean up
    rm "$APT_FILE"
else
    printf "Not synchronized.\n"
fi

printf "\n\e[34m%s\e[0m " "Syncronizing Virtual Box files."
read -p "Want to sync (y/N): " query
if [[ "$query" =~ ^(y|Y|yes|YES|Yes) ]]
then
    sudo rsync -vhuPr --delete "$VB_FILE" "$BCK_PATH"/virtualbox
else
    printf "Not synchronized.\n"
fi

printf "\n\e[34m%s\e[0m\n" "Finished Backup."

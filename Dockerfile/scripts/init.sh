#!/bin/bash

# Check if PUID and PGID are set and not root (0)
if [[ ! "${PUID}" -eq 0 ]] && [[ ! "${PGID}" -eq 0 ]]; then
    printf "\e[0;32m*****EXECUTING USERMOD*****\e[0m\n"
    # Change the user and group ID for the 'steam' user
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
else
    printf "\033[31mRunning as root is not supported, please fix your PUID and PGID!\n"
    exit 1
fi

# Create the directory and change its ownership
mkdir -p /palworld
chown -R steam:steam /palworld

# If UPDATE_ON_BOOT is set, update the server
if [ "${UPDATE_ON_BOOT}" = true ]; then
    printf "\e[0;32m*****STARTING INSTALL/UPDATE*****\e[0m\n"
    su steam -c '/usr/local/bin/box86 /home/steam/steamcmd.sh +force_install_dir "/palworld" +login anonymous +app_update 2394010 validate +quit'
fi

# Run the start script
./start.sh

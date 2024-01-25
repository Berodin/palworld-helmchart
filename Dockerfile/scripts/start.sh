#!/bin/bash

# Base start command
STARTCOMMAND="./PalServer.sh"

# Add various options based on environment variables
[ -n "${PLAYERS}" ] && STARTCOMMAND="${STARTCOMMAND} -players=${PLAYERS}"
[ "${COMMUNITY}" = true ] && STARTCOMMAND="${STARTCOMMAND} EpicApp=PalServer"
[ "${MULTITHREADING}" = true ] && STARTCOMMAND="${STARTCOMMAND} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"

# change values in configfile for passwords and IP
CONFIG_FILE="/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"
sed -i "s/\${ADMIN_PASSWORD}/$ADMIN_PASSWORD/g" $CONFIG_FILE
sed -i "s/\${SERVER_PASSWORD}/$SERVER_PASSWORD/g" $CONFIG_FILE
sed -i "s/\${PUBLIC_IP}/$PUBLIC_IP/g" $CONFIG_FILE

# Change to the game directory
cd /palworld 

# Display the start command (for verification)
echo "${STARTCOMMAND}"

# Server start message
printf "\e[0;32m*****STARTING SERVER*****\e[0m\n"

# Execute the start command as 'steam' user
FEXBash "${STARTCOMMAND}"

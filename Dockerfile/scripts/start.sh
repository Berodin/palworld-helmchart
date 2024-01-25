#!/bin/bash

# Base start command
STARTCOMMAND="./PalServer.sh"

# Add various options based on environment variables
[ -n "${PLAYERS}" ] && STARTCOMMAND="${STARTCOMMAND} -players=${PLAYERS}"
[ "${COMMUNITY}" = true ] && STARTCOMMAND="${STARTCOMMAND} EpicApp=PalServer"
[ "${MULTITHREADING}" = true ] && STARTCOMMAND="${STARTCOMMAND} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"

# Change to the game directory
cd /palworld 

# Display the start command (for verification)
echo "${STARTCOMMAND}"

# Server start message
printf "\e[0;32m*****STARTING SERVER*****\e[0m\n"

# Execute the start command as 'steam' user
FEXBash "${STARTCOMMAND}"

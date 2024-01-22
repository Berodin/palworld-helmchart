#!/bin/bash

# Base start command
STARTCOMMAND="./PalServer.sh"

# Add various options based on environment variables
[ -n "${PORT}" ] && STARTCOMMAND="${STARTCOMMAND} -port=${PORT}"
[ -n "${PLAYERS}" ] && STARTCOMMAND="${STARTCOMMAND} -players=${PLAYERS}"
[ "${COMMUNITY}" = true ] && STARTCOMMAND="${STARTCOMMAND} EpicApp=PalServer"
[ -n "${PUBLIC_IP}" ] && STARTCOMMAND="${STARTCOMMAND} -publicip=${PUBLIC_IP}"
[ -n "${PUBLIC_PORT}" ] && STARTCOMMAND="${STARTCOMMAND} -publicport=${PUBLIC_PORT}"
[ -n "${SERVER_NAME}" ] && STARTCOMMAND="${STARTCOMMAND} -servername=${SERVER_NAME}"
[ -n "${SERVER_PASSWORD}" ] && STARTCOMMAND="${STARTCOMMAND} -serverpassword=${SERVER_PASSWORD}"
[ -n "${ADMIN_PASSWORD}" ] && STARTCOMMAND="${STARTCOMMAND} -adminpassword=${ADMIN_PASSWORD}"
[ "${MULTITHREADING}" = true ] && STARTCOMMAND="${STARTCOMMAND} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"

# Change to the game directory
cd /palworld || exit

# Display the start command (for verification)
echo "${STARTCOMMAND}"

# Server start message
printf "\e[0;32m*****STARTING SERVER*****\e[0m\n"

# Execute the start command as 'steam' user
su steam -c "/usr/local/bin/box86 ${STARTCOMMAND}"

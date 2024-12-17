#!/bin/bash

# Base server start command
serverStartCommand="./PalServer.sh"
configDirectory="/palworld/Pal/Saved/Config/LinuxServer"
ADMIN_PASSWORD=${ADMIN_PASSWORD}
SERVER_PASSWORD=${SERVER_PASSWORD}
PUBLIC_IP=${PUBLIC_IP}

# Prepare an arm64-compatible server script
prepareArm64Server() {
    echo "Preparing arm64 version of the server script..."
    cp /palworld/PalServer.sh /palworld/PalServer-arm64.sh
    sed -i "s|\(\"\$UE_PROJECT_ROOT\/Pal\/Binaries\/Linux\/PalServer-Linux-Shipping\" Pal \"\$@\"\)|LD_LIBRARY_PATH=/home/steam/steamcmd/linux64:\$LD_LIBRARY_PATH /usr/local/bin/box64 \1|" /palworld/PalServer-arm64.sh
    chmod +x /palworld/PalServer-arm64.sh
    serverStartCommand="/palworld/PalServer-arm64.sh"
}

copyConfigFiles() {
    echo "Debugging before copying configuration files..."
    mkdir -p "${configDirectory}"
    echo "Config Directory: ${configDirectory}"

    if [ -f "/configs/PalWorldSettings.ini" ]; then
        echo "Copying /configs/PalWorldSettings.ini to ${configDirectory}"
        cp /configs/PalWorldSettings.ini "${configDirectory}/PalWorldSettings.ini"
    else
        echo "Error: /configs/PalWorldSettings.ini not found!"
    fi

    if [ -f "/configs/Engine.ini" ]; then
        echo "Copying /configs/Engine.ini to ${configDirectory}"
        cp /configs/Engine.ini "${configDirectory}/Engine.ini"
    else
        echo "Error: /configs/Engine.ini not found!"
    fi
}

# Adjust the server start command based on environment variables
adjustServerStartCommand() {
    [ -n "${PLAYERS}" ] && serverStartCommand="${serverStartCommand} -players=${PLAYERS}"
    [ "${COMMUNITY}" = true ] && serverStartCommand="${serverStartCommand} EpicApp=PalServer"
    if [ "${MULTITHREADING}" = true ]; then
        serverStartCommand="${serverStartCommand} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
    fi
}

updateOptionSettings() {
    local configFile="${configDirectory}/PalWorldSettings.ini"
    local newOptions="AdminPassword=${ADMIN_PASSWORD},ServerPassword=${SERVER_PASSWORD},PublicIP=${PUBLIC_IP}"

    echo "Updating OptionSettings in ${configFile}..."

    sed -i -E "/^\s*OptionSettings=\(.*\)/{
        s/^\s*OptionSettings=\((.*)\)/OptionSettings=(\1,${newOptions})/
        s/,,/,/g  # Doppelte Kommas entfernen
        s/\(,/\(/  # Komma nach öffnender Klammer entfernen
        s/,\)/)/   # Komma vor schließender Klammer entfernen
    }" "$configFile"
}

# Main script execution
prepareArm64Server
copyConfigFiles
adjustServerStartCommand
updateOptionSettings

chmod 444 "${configDirectory}/PalWorldSettings.ini"
chmod 444 "${configDirectory}/Engine.ini"

# Navigate to the game directory
cd /palworld

# Echo the final server start command for verification
echo "Final server start command: ${serverStartCommand}"

# Display a message indicating the server is starting
printf "\e[0;32m***** STARTING SERVER *****\e[0m\n"

# Execute the server start command under the 'steam' user
${serverStartCommand}
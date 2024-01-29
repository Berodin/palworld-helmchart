#!/bin/bash

# Initialize the base server start command
serverStartCommand="./PalServer.sh"
configDirectory="/palworld/Pal/Saved/Config/LinuxServer"
serverSettingsTempPath="/tmp/PalWorldSettings.ini" # Temporary path for server settings
gameUserSettingsTempPath="/tmp/GameUserSettings.ini" # Temporary path for game user settings
serverSettingsFilePath="${configDirectory}/PalWorldSettings.ini" # Server settings file path
gameUserSettingsFilePath="${configDirectory}/GameUserSettings.ini" # Game user settings file path. This file holds DedicatedServerName which is the name of the savefolder

# Copies the server settings and game user settings files to the server's configuration directory
copyConfigurationFiles() {
    echo "Creating configuration directory: ${configDirectory}"
    mkdir -p "${configDirectory}"
    echo "Copying temporary server settings file to: ${serverSettingsFilePath}"
    cp "${serverSettingsTempPath}" "${serverSettingsFilePath}"
    if [ -f "/tmp/GameUserSettings.ini" ]; then
        echo "Copying temporary game user settings file to: ${gameUserSettingsFilePath}"
        cp "${gameUserSettingsTempPath}" "${gameUserSettingsFilePath}"
    fi
}

# Adjusts the server start command based on environment variables
adjustServerStartCommand() {
    [ -n "${PLAYERS}" ] && serverStartCommand="${serverStartCommand} -players=${PLAYERS}"
    [ "${COMMUNITY}" = true ] && serverStartCommand="${serverStartCommand} EpicApp=PalServer"
    if [ "${MULTITHREADING}" = true ]; then
        serverStartCommand="${serverStartCommand} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
    fi
}

# Updates the server and game user configuration files with environment variables
updateConfigurationFiles() {
    echo "Assigning ownership of configuration files to 'steam' user"
    chown steam:steam "${serverSettingsFilePath}"
    chown steam:steam "${gameUserSettingsFilePath}"

    # Replace placeholders in server settings file with actual environment variable values
    echo "Updating server settings with environment variables"
    sed -i "s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g" "${serverSettingsFilePath}"
    sed -i "s/SERVER_PASSWORD/$SERVER_PASSWORD/g" "${serverSettingsFilePath}"
    sed -i "s/PUBLIC_IP/$PUBLIC_IP/g" "${serverSettingsFilePath}"

    # Additional updates for gameUserSettingsFilePath can be added here if needed

    # set Configfiles to readonly. This prevents the server to overwrite the pre-existing ones which default files and forces server to use existing ones.
    echo "Setting configuration files to read-only mode."
    chmod 444 "${serverSettingsFilePath}"
    if [ -f "/${gameUserSettingsFilePath}" ]; then
        chmod 444 "${gameUserSettingsFilePath}"
    fi
}

# Main script execution
copyConfigurationFiles
adjustServerStartCommand
updateConfigurationFiles

# Navigate to the game directory
cd /palworld

# Echo the final server start command for verification
echo "Final server start command: ${serverStartCommand}"

# Display a message indicating the server is starting
printf "\e[0;32m***** STARTING SERVER *****\e[0m\n"

# Execute the server start command under the 'steam' user
FEXBash "${serverStartCommand}"

#!/bin/bash

CONFIG_DIR="/palworld/Pal/Saved/Config/LinuxServer"
SERVER_CMD="./PalServer.sh"

# 1. Server-Startbefehl dynamisch anpassen
adjustServerStartCommand() {
    echo "Adjusting server start command..."
    [ -n "${PLAYERS}" ] && SERVER_CMD="${SERVER_CMD} -players=${PLAYERS}"
    [ "${COMMUNITY}" = "true" ] && SERVER_CMD="${SERVER_CMD} EpicApp=PalServer"
    [ "${MULTITHREADING}" = "true" ] && SERVER_CMD="${SERVER_CMD} -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
}

# 2. Konfiguration aktualisieren
updateConfigurationFiles() {
    echo "Updating configuration files with environment variables..."

    sed -i "s/ADMIN_PASSWORD/${ADMIN_PASSWORD}/g" "${CONFIG_DIR}/PalWorldSettings.ini"
    sed -i "s/SERVER_PASSWORD/${SERVER_PASSWORD}/g" "${CONFIG_DIR}/PalWorldSettings.ini"
    sed -i "s/PUBLIC_IP/${PUBLIC_IP}/g" "${CONFIG_DIR}/PalWorldSettings.ini"
    
    # Weitere Variablen können hier hinzugefügt werden
    chmod 444 "${CONFIG_DIR}"/*.ini
}

# 3. Skript ausführen
adjustServerStartCommand
updateConfigurationFiles

# 4. Server starten
echo "Starting server with command: ${SERVER_CMD}"
cd /palworld
FEXBash "${SERVER_CMD}"

#!/bin/bash

# Change ownership of the Palworld directory to the 'steam' user
sudo chown -R steam:steam /palworld

# Set the correct permissions for the Palworld directory
sudo chmod -R 775 /palworld

# Check if the server should be updated on boot
if [ "${UPDATE_ON_BOOT}" = "true" ]; then
    echo "***** STARTING INSTALL/UPDATE *****"
    # Update or install the Palworld server using steamcmd
    FEXBash "/home/steam/Steam/steamcmd.sh +force_install_dir /palworld +login anonymous +app_update 2394010 validate +quit"

    # Ensure the Steam SDK 64-bit directory exists
    mkdir -p ~/.steam/sdk64/
    
    # Update the Steam SDK and copy the steamclient.so to the sdk64 directory
    FEXBash "/home/steam/Steam/steamcmd.sh +login anonymous +app_update 1007 +quit" \
        && cp "/home/steam/Steam/steamapps/common/Steamworks SDK Redist/linux64/steamclient.so" ~/.steam/sdk64/
fi

# Execute the start script for the server
FEXBash /home/steam/start.sh

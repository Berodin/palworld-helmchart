#!/bin/bash

if [ "${UPDATE_ON_BOOT}" = "true" ]; then
    echo "***** STARTING INSTALL/UPDATE *****"
    # Update or install the Palworld server using steamcmd
    /home/steam/steamcmd/steamcmd.sh +force_install_dir /palworld +login anonymous +app_update 2394010 validate +quit
fi

# Ensure the Steam SDK 64-bit directory exists
mkdir -p ~/.steam/sdk64/

# Update the Steam SDK and copy the steamclient.so to the sdk64 directory
/home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit \
    && cp "/home/steam/Steam/steamapps/common/Steamworks SDK Redist/linux64/steamclient.so" ~/.steam/sdk64/

# Execute the start script for the server
/home/steam/start.sh

#!/bin/bash

sudo chown -R steam:steam /palworld
sudo chmod -R 775 /palworld

# If UPDATE_ON_BOOT is set, update the server
if [ "${UPDATE_ON_BOOT}" = "true" ]; then
    echo "***** STARTING INSTALL/UPDATE *****"
    FEXBash "/home/steam/Steam/steamcmd.sh +force_install_dir /palworld +login anonymous +app_update 2394010 validate +quit"

    mkdir -p ~/.steam/sdk64/ \
        && FEXBash "/home/steam/Steam/steamcmd.sh +login anonymous +app_update 1007 +quit" \
        && cp /home/steam/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ~/.steam/sdk64/
fi

# Run the start script
FEXBash /home/steam/start.sh

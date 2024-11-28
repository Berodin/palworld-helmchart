#!/bin/bash

CONFIG_DIR="/palworld/Pal/Saved/Config/LinuxServer"
TMP_CONFIG_DIR="/tmp/config"

DEBUG=${DEBUG:-false}
if [ "$DEBUG" = "true" ]; then
  set -x
fi

echo "***** Initializing Configuration *****"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating configuration directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

echo "Copying configuration files..."
cp "$TMP_CONFIG_DIR/PalWorldSettings.ini" "$CONFIG_DIR/PalWorldSettings.ini"
cp "$TMP_CONFIG_DIR/Engine.ini" "$CONFIG_DIR/Engine.ini"

if [ -f "$TMP_CONFIG_DIR/GameUserSettings.ini" ]; then
    cp "$TMP_CONFIG_DIR/GameUserSettings.ini" "$CONFIG_DIR/GameUserSettings.ini"
fi

echo "Setting permissions..."
chown -R steam:steam "$CONFIG_DIR"
chmod 444 "$CONFIG_DIR"/*.ini

if [ "${UPDATE_ON_BOOT}" = "true" ]; then
    echo "Updating server..."
    FEXBash "/home/steam/Steam/steamcmd.sh +force_install_dir /palworld +login anonymous +app_update 2394010 validate +quit"
fi

mkdir -p ~/.steam/sdk64/
FEXBash "/home/steam/Steam/steamcmd.sh +login anonymous +app_update 1007 +quit" \
    && cp "/home/steam/Steam/steamapps/common/Steamworks SDK Redist/linux64/steamclient.so" ~/.steam/sdk64/

echo "Starting server..."
FEXBash /home/steam/start.sh

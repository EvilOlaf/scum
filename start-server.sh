#!/bin/bash
set -e

# skip download of SteamCMD if present already
if [ ! -f /opt/steamcmd/steamcmd.sh ]; then
    echo "SteamCMD not found. Installing..."
    mkdir -p /opt/steamcmd && \
    cd /opt/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm /opt/steamcmd/steamcmd_linux.tar.gz && \
    echo "SteamCMD successfully installed" 
else
    echo "SteamCMD found, skipping installation..."
fi

echo "Update SteamCMD and SCUM dedicated server..."
/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows \
  +force_install_dir /opt/scumserver \
  +login anonymous \
  +app_update 3792580 validate \
  +quit

echo "Starting SCUM dedicated server..."
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
  wine /opt/scumserver/SCUM/Binaries/Win64/SCUMServer.exe \
    -log \
    -port=${PORT:-7777} \
    -QueryPort=${QUERYPORT:-27015} \
    -MaxPlayers=32

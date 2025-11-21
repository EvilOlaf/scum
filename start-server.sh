#!/bin/bash
set -e

echo "Installing/updating SCUM dedicated server..."
/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows \
  +force_install_dir /opt/scumserver \
  +login anonymous \
  +app_update 3792580 validate \
  +quit

echo "Starting SCUM dedicated server..."
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
  wine /opt/scumserver/SCUM/Binaries/Win64/SCUMServer.exe \
    -log \
    -port=7777 \
    -QueryPort=27015 \
    -MaxPlayers=32

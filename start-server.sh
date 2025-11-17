#!/bin/bash
set -e

echo "⏳ Initialisiere Wine..."

if ! command -v wine64 >/dev/null 2>&1; then
  echo "📦 Wine nicht gefunden, installiere..."
  dpkg --add-architecture i386
  apt-get update
  apt-get install -y wine wine64 wine32 libwine libwine:i386 winbind
fi

export WINEDEBUG=-all
export WINEARCH=win64
export WINEPREFIX=/opt/wine64

# Wine-Boot nur, wenn noch nicht initialisiert
if [ ! -d "$WINEPREFIX" ]; then
  wineboot --init && sleep 5
fi

echo "📥 Installiere/aktualisiere SCUM Dedicated Server..."
/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows \
  +login anonymous \
  +force_install_dir /opt/scumserver \
  +app_update 3792580 validate \
  +quit

echo "🚀 Starte SCUM Dedicated Server..."
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
  wine64 /opt/scumserver/SCUM/Binaries/Win64/SCUMServer.exe \
    -log \
    -port=7777 \
    -QueryPort=27015 \
    -MaxPlayers=32

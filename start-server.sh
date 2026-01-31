#!/bin/bash

cat << 'EOF'
                      _/_/_/    _/_/_/  _/    _/  _/      _/
                   _/        _/        _/    _/  _/_/  _/_/
                    _/_/    _/        _/    _/  _/  _/  _/
                       _/  _/        _/    _/  _/      _/
                _/_/_/      _/_/_/    _/_/    _/      _/

                           DEDICATED SERVER
                   https://github.com/EvilOlaf/scum

EOF

# workaround to avoid breaking existing installations
# if PORT is still used in docker-compose.yml, move its value to GAMEPORT and warn user.
if [[ -n "${PORT}" ]]; then
    echo 'ATTENTION!'
    echo '"PORT" environment variable is deprecated'
    echo 'and will be removed at some point.'
    echo 'Replace with "GAMEPORT" in your docker-compose.yml.'
    echo 'ATTENTION!'
    GAMEPORT="${GAMEPORT:-$PORT}"
fi

# skip download of SteamCMD if present already
if [ ! -f /opt/steamcmd/steamcmd.sh ]; then
    echo "SteamCMD not found. Installing..."
    mkdir -p /opt/steamcmd && \
    cd /opt/steamcmd && \
    wget --timeout=30 --tries=3 https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm /opt/steamcmd/steamcmd_linux.tar.gz && \
    echo "SteamCMD successfully installed" 
else
    echo "SteamCMD found, skipping installation..."
fi

# update SteamCMD and SCUM dedicated server
echo "Update SteamCMD and SCUM dedicated server..."
/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows \
  +force_install_dir /opt/scumserver \
  +login anonymous \
  +app_update 3792580 validate \
  +quit

echo "Starting SCUM dedicated server..."

# Handle shutdown signals gracefully, suppress false positive shellcheck warning
# shellcheck disable=SC2329
shutdown() {
    echo "Received shutdown signal, stopping server..."
    if [ -n "$SCUM_PID" ]; then
        echo "Sending SIGINT to SCUMServer.exe (PID $SCUM_PID)..."
        kill -INT "$SCUM_PID" 2>/dev/null || true

        # Wait up to 60 seconds for graceful shutdown
        for _ in {1..60}; do
            if ! kill -0 "$SCUM_PID" 2>/dev/null; then
                echo "Server stopped gracefully"
                exit 0
            fi
            sleep 1
        done

        echo "Server did not stop in time, forcing shutdown..."
        kill -KILL "$SCUM_PID" 2>/dev/null || true
    fi

    # Also stop the xvfb-run wrapper to clean up
    if [ -n "$WRAPPER_PID" ]; then
        kill -TERM "$WRAPPER_PID" 2>/dev/null || true
    fi

    exit 0
}

# Start server in background so we can handle signals
# Disable shellcheck warning, quoting does more harm than use in this particular case
# shellcheck disable=SC2086
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
  wine /opt/scumserver/SCUM/Binaries/Win64/SCUMServer.exe \
    -log \
    -port=${GAMEPORT:-7777} \
    -QueryPort=${QUERYPORT:-27015} \
    -MaxPlayers=${MAXPLAYERS:-32} \
    ${ADDITIONALFLAGS} &

WRAPPER_PID=$!
echo "Server wrapper started with PID $WRAPPER_PID"

# Wait for SCUMServer.exe to appear and get its PID
echo "Waiting for SCUMServer.exe process..."
SCUM_PID=""
for _ in {1..30}; do
    SCUM_PID="$(pgrep -f "Z:.*SCUMServer.exe" | head -1)"
    if [ -n "$SCUM_PID" ]; then
        echo "SCUMServer.exe found with PID $SCUM_PID"
        break
    fi
    sleep 1
done

if [ -z "$SCUM_PID" ]; then
    echo "ERROR: SCUMServer.exe process not found after 30 seconds"
    exit 1
fi

# Memory watchdog - monitor memory usage and trigger graceful shutdown if critical
MEMORY_THRESHOLD=${MEMORY_THRESHOLD_PERCENT:-95}
CHECK_INTERVAL=${MEMORY_CHECK_INTERVAL:-60}

if ! [[ "$MEMORY_THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "WARNING: Invalid MEMORY_THRESHOLD_PERCENT value '$MEMORY_THRESHOLD_PERCENT'. Forcing default: 95"
    MEMORY_THRESHOLD=95
fi
if ! [[ "$CHECK_INTERVAL" =~ ^[0-9]+$ ]] || [ "$CHECK_INTERVAL" -le 0 ]; then
    echo "WARNING: Invalid MEMORY_CHECK_INTERVAL value '$MEMORY_CHECK_INTERVAL'. Forcing default: 60"
    CHECK_INTERVAL=60
fi

if [ "$MEMORY_THRESHOLD" -gt 0 ]; then
    echo "Memory watchdog enabled: shutdown when available memory usag exceeds ${MEMORY_THRESHOLD}% (checking every ${CHECK_INTERVAL}s)"
    (
        while true; do
            MEM_USAGE=$(LC_ALL=C free | awk '/Mem/{printf("%.0f"), ($2-$7)/$2*100}')
            if [ "$MEM_USAGE" -ge "$MEMORY_THRESHOLD" ]; then
                echo "Memory watchdog triggered: memory usage is ${MEM_USAGE}%! Initiating graceful shutdown to prevent data loss..."
                kill -INT "$SCUM_PID" 2>/dev/null || true
                break
            fi
            sleep $CHECK_INTERVAL
        done
    ) &
    echo "Memory watchdog started."
else
    echo "Memory watchdog disabled (MEMORY_THRESHOLD_PERCENT set to 0)"
fi

# Now that SCUM_PID is known, set up signal handlers
trap shutdown SIGTERM SIGINT

# Wait for server process
wait $WRAPPER_PID
exit_code=$?
echo "Server exited with code $exit_code"
exit $exit_code

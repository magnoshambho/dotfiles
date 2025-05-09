#!/usr/bin/env bash

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch Waybar, using default config location ~/.config/waybar/config.jsonc
waybar &

echo "Waybar launched..."

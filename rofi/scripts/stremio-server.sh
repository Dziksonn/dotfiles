#!/usr/bin/env bash

STREMIO_PATH=$(find /nix/store -maxdepth 5 -name "server.js" 2>/dev/null \
  | grep -i stremio \
  | head -1)

if [[ -z "$STREMIO_PATH" ]]; then
    notify-send "Stremio" "server.js not found in nix store"
    exit 1
fi

setsid kitty --title "Stremio Server" nix-shell -p nodejs --run "node $STREMIO_PATH" &>/dev/null &

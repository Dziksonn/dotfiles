#!/usr/bin/env bash
STATE_FILE="/tmp/hypr-waybar-lock"
HYPRCTL=/run/current-system/sw/bin/hyprctl
WAYBAR_CONFIG="$HOME/.config/waybar/config"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    $HYPRCTL keyword unbind ", SUPER_L"
    $HYPRCTL keyword bindit  ", SUPER_L, exec, pkill -SIGUSR1 waybar"
    $HYPRCTL keyword binditr ", SUPER_L, exec, pkill -SIGUSR1 waybar"
    sed -i 's/"mode": "dock"/"mode": "hide"/' "$WAYBAR_CONFIG"
    pkill -SIGUSR2 waybar
    sleep 0.2
    pkill -SIGUSR1 waybar
    notify-send -t 1000 "waybar unlocked"
else
    touch "$STATE_FILE"
    $HYPRCTL keyword unbind ", SUPER_L"
    $HYPRCTL keyword bindit  ", SUPER_L, exec, true"
    $HYPRCTL keyword binditr ", SUPER_L, exec, true"
    sed -i 's/"mode": "hide"/"mode": "dock"/' "$WAYBAR_CONFIG"
    pkill -SIGUSR2 waybar
    sleep 0.2
    pkill -SIGUSR1 waybar
    notify-send -t 1000 "waybar locked"
fi
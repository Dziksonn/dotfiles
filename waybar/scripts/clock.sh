#!/usr/bin/env bash

declare -A zones=(
    ["🌐 UTC"]="Etc/UTC"
    ["🗽 New York"]="America/New_York"
    ["🌴 Los Angeles"]="America/Los_Angeles"
    ["🇨🇦 Toronto"]="America/Toronto"
    ["🇧🇷 São Paulo"]="America/Sao_Paulo"
    ["🇦🇷 Buenos Aires"]="America/Argentina/Buenos_Aires"
    ["🇺🇾 Montevideo"]="America/Montevideo"
    ["🇬🇧 London"]="Europe/London"
    ["🇫🇷 Paris"]="Europe/Paris"
    ["🇩🇪 Berlin"]="Europe/Berlin"
    ["🇷🇺 Moscow"]="Europe/Moscow"
    ["🇦🇪 Dubai"]="Asia/Dubai"
    ["🇮🇳 Mumbai"]="Asia/Kolkata"
    ["🇧🇩 Dhaka"]="Asia/Dhaka"
    ["🇨🇳 Shanghai"]="Asia/Shanghai"
    ["🇸🇬 Singapore"]="Asia/Singapore"
    ["🇯🇵 Tokyo"]="Asia/Tokyo"
    ["🇰🇷 Seoul"]="Asia/Seoul"
    ["🇦🇺 Sydney"]="Australia/Sydney"
    ["🇳🇿 Auckland"]="Pacific/Auckland"
)

order=(
    "🌐 UTC"
    "🗽 New York"
    "🌴 Los Angeles"
    "🇨🇦 Toronto"
    "🇧🇷 São Paulo"
    "🇦🇷 Buenos Aires"
    "🇺🇾 Montevideo"
    "🇬🇧 London"
    "🇫🇷 Paris"
    "🇩🇪 Berlin"
    "🇷🇺 Moscow"
    "🇦🇪 Dubai"
    "🇮🇳 Mumbai"
    "🇧🇩 Dhaka"
    "🇨🇳 Shanghai"
    "🇸🇬 Singapore"
    "🇯🇵 Tokyo"
    "🇰🇷 Seoul"
    "🇦🇺 Sydney"
    "🇳🇿 Auckland"
)

tooltip=""
for label in "${order[@]}"; do
    tz="${zones[$label]}"
    time=$(TZ="$tz" date +"%H:%M %Z")
    tooltip+="$label  $time\\n"
done

tooltip="${tooltip%\\n}"

current_time=$(date +"%H:%M")

echo "{\"text\": \"$current_time\", \"tooltip\": \"$tooltip\"}"
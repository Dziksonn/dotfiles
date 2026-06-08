#!/usr/bin/env bash
SCRIPTS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts"

if [[ -z "$1" ]]; then
    find "$SCRIPTS_DIR" -maxdepth 1 -name "*.sh" ! -name "scripts.sh" \
      | sort | xargs -I{} basename {} .sh
else
    /usr/bin/env bash "$SCRIPTS_DIR/$1.sh"
fi

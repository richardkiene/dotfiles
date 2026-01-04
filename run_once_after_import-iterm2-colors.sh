#!/bin/bash
# Import iTerm2 color presets

set -euo pipefail

COLORS_DIR="$HOME/Library/Application Support/iTerm2/ColorPresets"
COLOR_FILE="$COLORS_DIR/GitHub Dark.itermcolors"

if [[ -f "$COLOR_FILE" ]]; then
    echo "Importing iTerm2 color preset: GitHub Dark"
    open "$COLOR_FILE"
    echo "Color preset imported. You can select it in iTerm2: Preferences → Profiles → Colors → Color Presets"
else
    echo "Color preset file not found: $COLOR_FILE"
    exit 1
fi

#!/bin/bash
export PATH="/opt/homebrew/bin:/Users/jasperdavidson/.cargo/bin:$PATH"
WALL=$(ls ~/wallpapers/*.{jpg,png,jpeg} 2>/dev/null | gshuf -n 1)
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WALL\""
matugen image "$WALL" --source-color-index 0 --config ~/.config/matugen/config.toml

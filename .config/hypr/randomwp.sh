#!/bin/bash
WPDIR="$HOME/.config/hypr/wallpapers"

hyprctl monitors -j | jq -r '.[].name' | shuf | while read -r monitor; do
	WALLPAPER=$(find "$WPDIR" -type f | shuf -n 1)
	[ -n "$WALLPAPER" ] || exit 1
	ln -sf "$WALLPAPER" "$XDG_RUNTIME_DIR/currentwp.png" # used by hyprlock
	hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
done

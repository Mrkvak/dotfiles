#!/bin/bash
sleep 3
WPDIR="$HOME/.config/hypr/wallpapers"

MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
for monitor in ${MONITORS}; do
	WALLPAPER=$(find "${WPDIR}" | shuf -n 1 )
	hyprctl hyprpaper preload "${WALLPAPER}"
	hyprctl hyprpaper wallpaper "${monitor},${WALLPAPER}"
done
hyprctl hyprpaper unload all

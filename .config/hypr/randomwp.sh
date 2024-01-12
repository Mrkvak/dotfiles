#!/bin/bash
sleep 3
WPDIR="$HOME/.config/hypr/wallpapers"

MONITORS=$(hyprctl monitors -j | jq -r '.[].name')
for monitor in ${MONITORS}; do
	WALLPAPER=$(ls -1 "${WPDIR}" | shuf -n 1 )
	hyprctl hyprpaper preload "${WPDIR}/${WALLPAPER}"
	hyprctl hyprpaper wallpaper "${monitor},${WPDIR}/${WALLPAPER}"
done
hyprctl hyprpaper unload all

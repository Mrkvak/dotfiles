#!/bin/bash
WPDIR="$HOME/.config/hypr/wallpapers"

MONITORS=$(hyprctl monitors -j | jq -r '.[].name'|shuf)
for monitor in ${MONITORS}; do
	WALLPAPER=$(find "${WPDIR}" -type f| shuf -n 1 )
	ln -sf $WALLPAPER ${XDG_RUNTIME_DIR}/currentwp.png
	hyprctl hyprpaper preload "${WALLPAPER}"
	hyprctl hyprpaper wallpaper "${monitor},${WALLPAPER}"
done
hyprctl hyprpaper unload unused

#!/bin/bash

case "$1" in
	"ntb|work|srv")
		;;
	*)
		echo "Usage: $0 ntb|work|srv"
		exit 1
		;;
esac

if [ "$1" = "srv" ]; then
	excludes="install.sh *.tpl .git .icons .themes .config/foot .config/hypr .config/swayidle .config/swaylock .config/waybar .config/wofi" 
else
	excludes="install.sh *.tpl .git"
fi

args=""
for exclude in $excludes; do
	args="$args --exclude $exclude"
done
rsync -av ./ "$HOME/" $excludes


find . -name "*.tpl"| while read -r i; do
	echo "Post-processing $i"
	TGTN=${i//.tpl/}
	unifdef -t -Untb -Uwork "-D$1" "$i" > "$HOME/$TGTN"
done

if [ "$1" != "srv" ]; then
	gsettings set org.gnome.desktop.interface gtk-theme oomox-mrkvoschema
	gsettings set org.gnome.desktop.interface icon-theme oomox-mrkvoschema
fi

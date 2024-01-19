#!/bin/bash

if [ $# -ne 1 ] || { [ "$1" != "ntb" ] && [ "$1" != "work" ];}; then
	echo "Usage: $0 ntb|work"
	exit 1
fi


rsync -av ./ "$HOME/" --exclude "install.sh" --exclude "*.tpl" --exclude ".git"


find . -name "*.tpl"| while read -r i; do
	echo "Post-processing $i"
	TGTN=${i//.tpl/}
	unifdef -t -Untb -Uwork "-D$1" "$i" > "$HOME/$TGTN"
done

gsettings set org.gnome.desktop.interface gtk-theme oomox-mrkvoschema
gsettings set org.gnome.desktop.interface icon-theme oomox-mrkvoschema

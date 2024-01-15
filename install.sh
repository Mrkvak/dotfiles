#!/bin/bash

if [ $# -ne 1 ] || ( [ "$1" != "ntb" ] && [ "$1" != "work" ]); then
	echo "Usage: $0 ntb|work"
	exit 1
fi


rsync -av ./ $HOME/ --exclude "install.sh" --exclude "*.tpl" --exclude ".git"


for i in $(find . -name "*.tpl"); do
	echo "Post-processing $i"
	TGTN=$(echo "$i" | sed 's/.tpl$//')
	unifdef -t -Untb -Uwork -D$1 $i > $HOME/$TGTN
done

gsettings set org.gnome.desktop.interface gtk-theme oomox-mrkvoschema
gsettings set org.gnome.desktop.interface icon-theme oomox-mrkvoschema

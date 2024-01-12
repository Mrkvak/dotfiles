#!/bin/bash

if [ $# -ne 1 ] || ( [ "$1" != "ntb" ] && [ "$1" != "work" ]); then
	echo "Usage: $0 ntb|work"
	exit 1
fi


rsync -av ./ $HOME/ --exclude "install.sh" --exclude "*.tpl"


for i in $(find . -name "*.tpl"); do
	echo "Post-processing $i"
	TGTN=$(echo "$i" | sed 's/.tpl$//')
	unifdef -t -Uhome -Uwork -D$1 $i > $HOME/$TGTN
done

#!/bin/bash
mkdir -p ~/screenshots
DATE=$(date "+%Y-%m-%d_%H-%M-%S")

I=0

while true; do
	SUFFIX=$(printf "%02d" "$I")
	FN=~/screenshots/${DATE}_${SUFFIX}.png
	if [ ! -e "$FN" ]; then
		break
	fi
	I=$((I+1))
done
grim "$FN"

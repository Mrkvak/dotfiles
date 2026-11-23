#!/bin/bash
# Usage: screenshot.sh [full|region]
# Saves to ~/screenshots and, if wl-copy is available, copies the image to the clipboard.
mode=${1:-full}

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

case $mode in
	region)
		if ! command -v slurp >/dev/null; then
			echo "screenshot.sh: region mode needs slurp" >&2
			exit 1
		fi
		GEOM=$(slurp) || exit 0 # selection cancelled
		grim -g "$GEOM" "$FN" || exit 1
		;;
	*)
		grim "$FN" || exit 1
		;;
esac

if command -v wl-copy >/dev/null; then
	wl-copy --type image/png < "$FN"
fi

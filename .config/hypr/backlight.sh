#!/bin/bash

BL_DRIVER=amdgpu_bl0

STEP_DEFAULT=10

BL_CURRENT=$(cat /sys/class/backlight/$BL_DRIVER/brightness)
BL_MAX=$(cat /sys/class/backlight/$BL_DRIVER/max_brightness)
STEP_DEFAULT=$((BL_MAX/10))

if [ -n "$2" ]; then
	STEP=$2
else
	STEP=$STEP_DEFAULT
fi


case $1 in
	inc)
		BL_NEW=$((BL_CURRENT+STEP))
		if [ "$BL_NEW" -gt "$BL_MAX" ]; then
			BL_NEW=$BL_MAX
		fi
		;;
	dec)
		BL_NEW=$((BL_CURRENT-STEP))
		if [ "$BL_NEW" -lt 0 ]; then
			BL_NEW=0
		fi
		;;
	*)
		echo "$BL_CURRENT*100/$BL_MAX" | bc
		exit 0
		;;
esac

echo "$BL_NEW" > /sys/class/backlight/$BL_DRIVER/brightness

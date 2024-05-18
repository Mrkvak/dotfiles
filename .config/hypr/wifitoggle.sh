#!/bin/bash
if sudo /etc/init.d/wpa_supplicant status >/dev/null; then
	sudo /etc/init.d/wpa_supplicant stop
	sleep 3
	sudo /usr/local/sbin/rfkill.sh phy0 0
else
	sudo /etc/init.d/wpa_supplicant start
	sleep 3
	sudo /usr/local/sbin/rfkill.sh phy0 1
fi


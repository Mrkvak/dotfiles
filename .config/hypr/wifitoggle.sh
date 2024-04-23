#!/bin/bash
if sudo /etc/init.d/wpa_supplicant status >/dev/null; then
	sudo /etc/init.d/wpa_supplicant stop
	sudo /usr/local/sbin/rfkill phy0 0
else
	sudo /etc/init.d/wpa_supplicant start
	sudo /usr/local/sbin/rfkill phy0 1
fi


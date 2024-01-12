#!/bin/bash
if sudo /etc/init.d/wpa_supplicant status >/dev/null; then
	sudo /etc/init.d/wpa_supplicant stop
else
	sudo /etc/init.d/wpa_supplicant start
fi


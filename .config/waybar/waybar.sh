#!/bin/bash
# Custom waybar module (VPN status). Everything else uses waybar's built-in modules.

json() {
	# $1 = text, $2 = optional class
	jq -cn --arg t "$1" --arg c "${2:-}" 'if $c == "" then {text: $t} else {text: $t, class: $c} end'
}

vpn() {
	VPN_STR=""
	for i in /etc/init.d/openvpn*; do
		VPN_NAME=$(echo "$i" | cut -d '.' -f 3)
		if [ -z "$VPN_NAME" ]; then
			VPN_NAME="default"
		fi

		if $i status >/dev/null; then
			if [ -z "$VPN_STR" ]; then
				VPN_STR="$VPN_NAME"
			else
				VPN_STR="$VPN_STR,$VPN_NAME"
			fi
		fi
	done
	VPN_URGENT="alert"
	if [ -z "$VPN_STR" ]; then
		VPN_STR="NONE"
		VPN_URGENT="normal"
	fi

	json "VPN:$VPN_STR" "$VPN_URGENT"
}

case "$1" in
	vpn)
		"$1"
		;;
	*)
		echo "Usage: $0 vpn" >&2
		exit 1
		;;
esac

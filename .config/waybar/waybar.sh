#!/bin/bash
vpn() {
	VPN_STR=""
	for i in /etc/init.d/openvpn*; do
		VPN_NAME=$(echo $i | cut -d '.' -f 3)
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

	printf "{\"text\": \"VPN:%s\", \"class\": \"%s\"},\n" "$VPN_STR" "$VPN_URGENT"
}

network() {
	NETSTATUS=""
	IFACE_UP=$(ip -j a l | jq -r '.[] | select(.operstate == "UP").ifname')
	
	WLAN_IFACE=$(echo "$IFACE_UP" | grep wlan)
	ETH_IFACE=$(echo "$IFACE_UP" | grep eth)

	if [ -n "$IFACE_UP" ]; then
		TXB_PREV=$(cat /tmp/waybar_net_txb)
		RXB_PREV=$(cat /tmp/waybar_net_rxb)
		STAMP_PREV=$(cat /tmp/waybar_net_stamp)

		TXB_CUR=$(cat /sys/class/net/${IFACE_UP}/statistics/tx_bytes)
		RXB_CUR=$(cat /sys/class/net/${IFACE_UP}/statistics/rx_bytes)
		STAMP_CUR=$(date +%s)

		DELTA_SECONDS=$((STAMP_CUR-STAMP_PREV))

		TXB_DELTA=$((TXB_CUR - TXB_PREV))
		RXB_DELTA=$((RXB_CUR - RXB_PREV))

		TXB_RATE=$(echo "$TXB_DELTA / $DELTA_SECONDS" | bc 2>/dev/null| numfmt --to=si --suffix "B/s" --format %3.1f)
		RXB_RATE=$(echo "$RXB_DELTA / $DELTA_SECONDS" | bc 2>/dev/null| numfmt --to=si --suffix "B/s" --format %3.1f)
	

		if [ -z "$TXB_RATE" ] || [ -z "$RXB_RATE" ] || [ -z "$DELTA_SECONDS" ]; then
			TXB_RATE=$(cat /tmp/waybar_net_txb_rate)
			RXB_RATE=$(cat /tmp/waybar_net_rxb_rate)
		else
			echo "$TXB_CUR" > /tmp/waybar_net_txb
			echo "$RXB_CUR" > /tmp/waybar_net_rxb
			echo "$STAMP_CUR" > /tmp/waybar_net_stamp

			echo "$TXB_RATE" > /tmp/waybar_net_txb_rate
			echo "$RXB_RATE" > /tmp/waybar_net_rxb_rate

		fi
		SPEED_SUFFIX="$TXB_RATE | $RXB_RATE"
	else
		SPEED_SUFFIX=""
	fi

	if [ -n "$WLAN_IFACE" ]; then
		SSID=$(iwgetid -r)
		if [ -z "$SSID" ]; then
			SSID="connecting..."
		fi
		IP=$(ip -j a l dev $WLAN_IFACE| jq -r '.[] | select(.operstate == "UP").addr_info[] | select(.family == "inet").local')
		SIGNAL=$(awk "/${WLAN_IFACE}/{gsub(/\\./, \"\", \$4); print \$4}" /proc/net/wireless)
		NETSTATUS="${NETSTATUS}$IP ($SSID, ${SIGNAL}dBm) | $SPEED_SUFFIX"

	fi

	if [ -n "$ETH_IFACE" ]; then
		IP=$(ip -j a l dev $ETH_IFACE| jq -r '.[] | select(.operstate == "UP").addr_info[] | select(.family == "inet").local')
		NETSTATUS="${NETSTATUS} $IP | $SPEED_SUFFIX"
	fi

	if [ -z "$NETSTATUS" ]; then
		if pgrep wpa_supplicant >/dev/null; then
			NETSTATUS="WiFi ON"
		else
			NETSTATUS="OFFLINE"
		fi
	fi

	
	printf "{\"text\": \"%s\"},\n" "$NETSTATUS"

}

volume() {
	VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@|grep Volume:|awk '{print $5}')
	if pactl get-sink-mute @DEFAULT_SINK@|grep -q yes; then
		VOLUME_ICON=""
	else
		VOLUME_ICON=$(printf "🔊")
	fi

	printf "{\"text\": \"%s %+4s%s\"},\n" "$VOLUME_ICON" "$VOLUME"
}

cpu() {
	CPU_USAGE=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
	CPU_LOAD=$(cat /proc/loadavg |cut -d ' ' -f 1)
	CPU_LOAD_COARSE=$(echo $CPU_LOAD | cut -d '.' -f 1)
	CPU_CORES=$(cat /proc/cpuinfo|grep processor|wc -l)
	if [ $CPU_LOAD_COARSE -gt $CPU_CORES ]; then
		CPU_CRIT="alert"
	else
		CPU_CRIT="normal"
	fi

	CPU_TEMP=$(echo "$(cat /sys/class/hwmon/hwmon0/temp1_input)/1000" | bc)
	if [ -z "$CPU_TEMP" ]; then
		CPU_TEMP=$(echo "$(cat /sys/class/hwmon/hwmon1/temp1_input)/1000" | bc)
	fi
	if [ -z "$CPU_TEMP" ]; then
		CPU_TEMP="??"
	elif [ $CPU_TEMP -gt 90 ]; then
		CPU_CRIT="alert"
	fi

	printf "{\"text\": \"%+3s%% / %+2s / %+2s°C\", \"class\": \"%s\"},\n" "$CPU_USAGE" "$CPU_LOAD" "$CPU_TEMP" "$CPU_CRIT"
}

mem() {
	MEM_TOTAL=$(free -m|grep Mem|awk '{print $2}')
	MEM_USED=$(free -m|grep Mem|awk '{print $3}')
	MEM_AVAILABLE=$(free -m|grep Mem|awk '{print $7}')

	if [ $MEM_AVAILABLE -lt 500 ]; then
		MEM_CRIT="alert"
	else
		MEM_CRIT="normal"
	fi

	printf "{\"text\": \" %sMB / %sMB\", \"class\": \"%s\"},\n" "$MEM_USED" "$MEM_TOTAL" "$MEM_CRIT"
}

battery() {
	BAT_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
	if [ $BAT_LEVEL -lt 10 ]; then
		BAT_CRIT=alert
		BAT_STATE=""
	else
		BAT_CRIT=normal
		BAT_STATE=""
	fi
	if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
		BAT_STATE=""
		BAT_CRIT=normal
#	else
#		BAT_STATE=""
	fi

	BAT_ENERGY=$(cat /sys/class/power_supply/BAT0/energy_now)
	BAT_ENERGY_FULL=$(cat /sys/class/power_supply/BAT0/energy_full)

	BAT_POWER=$(cat /sys/class/power_supply/BAT0/power_now)

	BAT_POWER_PRETTY=$(awk '{printf "%2.2fW", $1*10^-6}' /sys/class/power_supply/BAT0/power_now)

        if grep -q Discharging /sys/class/power_supply/BAT0/status; then
                BAT_ENERGY_REMAINING=$BAT_ENERGY
        else
                BAT_ENERGY_REMAINING=$((BAT_ENERGY_FULL-BAT_ENERGY))
        fi

	if [ $BAT_POWER -gt 0 ]; then
		REMAINING_HOURS=$((BAT_ENERGY_REMAINING/BAT_POWER))
		REMAINING_MINS=$(((BAT_ENERGY_REMAINING-(REMAINING_HOURS*BAT_POWER))*60/BAT_POWER))
	else
		REMAINING_HOURS="--"
		REMAINING_MINS="--"
	fi

	printf "{\"text\": \"%s%+3s%% [%+2s:%+2s] [%+6s]\", \"class\": \"%s\"},\n" "$BAT_STATE" "$BAT_LEVEL" "$REMAINING_HOURS" "$REMAINING_MINS" "$BAT_POWER_PRETTY" "$BAT_CRIT"
}


brightness() {
	BRT_LEVEL=$(~/.config/sway/backlight.sh)
	printf "{\"text\": \"\uf109%+3s%%\"},\n" "$BRT_LEVEL"
}

datetime() {
	DATE=$(date +'%Y-%m-%d %I:%M:%S')
	echo "{\"text\": \"${DATE}\" }"
}

keyboard() {
	KBDDEV=keychron-keychron-k1
	MAP=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name == \"$KBDDEV\").active_keymap")
	if [ -z "$MAP" ]; then
		KBDDEV=at-translated-set-2-keyboard
		MAP=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name == \"$KBDDEV\").active_keymap")
	fi

	case $MAP in
		"English (US)")
			MAP="US"
			;;
		"Czech")
			MAP="CZ"
			;;
		*)
			MAP="??"
			;;
	esac

	echo "{\"text\": \"${MAP}\" }"
}

if [ "$1" != "" ]; then
	$1
	exit 0
fi

while true; do
	echo '{ "version": 1 }'
	echo -n "["

	echo "["
	vpn
	network
	brightness
	volume
	cpu
	mem
	battery
	datetime

	echo "],"
done

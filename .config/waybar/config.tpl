		{
    "height": 30, // Waybar height (to be removed for auto height)
    "spacing": 4, // Gaps between modules (4px)

    "modules-left": ["hyprland/workspaces", "custom/separator", "hyprland/window"],
    // NOTEBOOK:
#ifdef ntb
    "modules-right": ["custom/separator", "hyprland/language", "custom/separator", "custom/vpn", "custom/separator", "network", "custom/separator", "backlight", "custom/separator", "wireplumber", "custom/separator", "cpu", "temperature", "custom/separator", "memory", "custom/separator", "battery", "custom/separator", "clock", "tray"],
#endif


    // WORK DESKTOP:
#ifdef work
	"modules-right": ["custom/separator", "hyprland/language", "custom/separator", "network", "custom/separator", "wireplumber", "custom/separator", "cpu", "temperature", "custom/separator", "memory", "custom/separator", "clock", "tray"],
#endif


	"hyprland/workspaces": {
     	"format": "{icon}",
		"on-scroll-up": "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'",
		"on-scroll-down": "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'"
	},
	"hyprland/window": {
		"max-length": 200,
	     "separate-outputs": true
	},

	"custom/separator": {
	    "format": "|",
		"interval": "once",
		"tooltip": false
	},

	"hyprland/language": {
		// shows "us" / "cz"; per-language "format-en" etc. disables the module in waybar 0.15
		"format": "{short}",
		"min-length": 2 // label starts empty; without this it stays squeezed to "…"
	},

	"custom/vpn": {
		"exec": "$HOME/.config/waybar/waybar.sh vpn",
		"return-type": "json",
		"interval": 30
	},

	"network": {
		"interval": 5,
		"format-wifi": "\uf1eb{ipaddr} ({essid}, {signaldBm}dBm) | \uf062{bandwidthUpBytes} | \uf063{bandwidthDownBytes}",
		"format-ethernet": "\uf6ff {ipaddr} | \uf062{bandwidthUpBytes} | \uf063{bandwidthDownBytes}",
		"format-linked": "{ifname} (no IP)",
		"format-disconnected": "OFFLINE",
		"tooltip-format": "{ifname} via {gwaddr}"
	},

	"backlight": {
		"device": "amdgpu_bl0",
		"format": "{percent:>3}%"
	},

	"wireplumber": {
		"format": "🔊 {volume:>3}%",
		"format-muted": " {volume:>3}%",
		"max-volume": 100
	},

	"cpu": {
		"interval": 5,
		"format": "\uf2db{usage:>3}% / {load:.2f} /",
		"states": { "critical": 95 }
	},

	"temperature": {
		// k10temp; same PCI path on both machines, unlike the hwmonN number
		"hwmon-path-abs": "/sys/devices/pci0000:00/0000:00:18.3/hwmon",
		"input-filename": "temp1_input",
		"critical-threshold": 90,
		"format": "{temperatureC}°C"
	},

	"memory": {
		"interval": 5,
		"format": " {used:0.1f}G / {total:0.1f}G",
		"states": { "critical": 90 }
	},

	"battery": {
		"bat": "BAT0",
		"adapter": "AC",
		"interval": 30,
		"states": { "critical": 10 },
		"format": "{capacity:>3}% [{time}] [{power:.2f}W]",
		"format-critical": "{capacity:>3}% [{time}] [{power:.2f}W]",
		"format-charging": "{capacity:>3}% [{time}] [{power:.2f}W]",
		"format-plugged": "{capacity:>3}% [{power:.2f}W]",
		"format-time": "{H}:{m}"
	},

    "tray": {
        // "icon-size": 21,
        "spacing": 10
    },
    "clock": {
//        "timezone": "Europe/Prague",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": "{:%Y-%m-%d %H:%M:%S}",
	   "interval": 1
    },
}

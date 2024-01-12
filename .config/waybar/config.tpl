{
    "height": 30, // Waybar height (to be removed for auto height)
    "spacing": 4, // Gaps between modules (4px)

    "modules-left": ["hyprland/workspaces", "custom/separator", "hyprland/window"],
    // NOTEBOOK: 
#ifdef ntb
    "modules-right": ["custom/separator", "custom/keyboard", "custom/separator", "custom/vpn", "custom/separator", "custom/network", "custom/separator", "custom/brightness", "custom/separator", "custom/volume", "custom/separator", "custom/cpu", "custom/separator", "custom/mem", "custom/separator", "custom/battery", "custom/separator", "clock", "tray"],
#endif


    // WORK DESKTOP:
#ifdef work
	"modules-right": ["custom/separator", "custom/keyboard", "custom/separator", "custom/network", "custom/separator", "custom/volume", "custom/separator", "custom/cpu", "custom/separator", "custom/mem", "custom/separator", "clock", "tray"],
#endif


	"hyprland/workspaces": {
     	"format": "{icon}",
		"on-scroll-up": "hyprctl dispatch workspace e+1",
		"on-scroll-down": "hyprctl dispatch workspace e-1"
	},
	"hyprland/window": {
		"max-length": 200,
	     "separate-outputs": true
	},

	"custom/brightness": {
		"exec": "$HOME/.config/waybar/waybar.sh brightness",
		"return-type": "json",
		"interval": 1
	},

	"custom/vpn": {
		"exec": "$HOME/.config/waybar/waybar.sh vpn",
		"return-type": "json",
		"interval": 5
	},
	"custom/separator": {
	    "format": "|",
		"interval": "once",
		"tooltip": false
	},

	"custom/network": {
		"exec": "$HOME/.config/waybar/waybar.sh network",
		"return-type": "json",
		"interval": 5
	},

	"custom/volume": {
		"exec": "$HOME/.config/waybar/waybar.sh volume",
		"return-type": "json",
		"interval": 1
	},

	"custom/cpu": {
		"exec": "$HOME/.config/waybar/waybar.sh cpu",
		"return-type": "json",
		"interval": 1
	},

	"custom/mem": {
		"exec": "$HOME/.config/waybar/waybar.sh mem",
		"return-type": "json",
		"interval": 1
	},

	"custom/battery": {
		"exec": "$HOME/.config/waybar/waybar.sh battery",
		"return-type": "json",
		"interval": 1
	},

	"custom/keyboard": {
		"exec": "$HOME/.config/waybar/waybar.sh keyboard",
		"return-type": "json",
		"interval": 1
	},

    "tray": {
        // "icon-size": 21,
        "spacing": 10
    },
    "clock": {
        // "timezone": "America/New_York",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": "{:%Y-%m-%d %I:%M:%S}",
	   "interval": 1
    },
}


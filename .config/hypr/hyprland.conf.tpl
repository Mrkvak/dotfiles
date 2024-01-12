# WORK DESKTOP SETTINGS:
#ifdef work
$monitor_left=HDMI-A-1
$monitor_center=DP-1
$monitor_right=HDMI-A-2
monitor=$monitor_left,2560x1440,0x0,1
monitor=$monitor_center,2560x1440,2560x0,1
monitor=$monitor_right,2560x1440,5120x0,1
#endif

# HOME SETTINGS:
#ifdef ntb
monitor=,highres,auto,1
$monitor_left=eDP-1
$monitor_center=eDP-1
$monitor_right=eDP-1
#endif

workspace=1,monitor:$monitor_left
workspace=2,monitor:$monitor_left
workspace=3,monitor:$monitor_left
workspace=4,monitor:$monitor_left

workspace=5,monitor:$monitor_center
workspace=6,monitor:$monitor_center
workspace=7,monitor:$monitor_center
workspace=8,monitor:$monitor_center

workspace=9,monitor:$monitor_right
workspace=10,monitor:$monitor_right
workspace=11,monitor:$monitor_right
workspace=12,monitor:$monitor_right

$terminal = foot
$fileManager = dolphin
$menu = wofi --show drun

env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that

#env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
#env = GBM_BACKEND,nvidia-drm
#env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1

input {
    kb_layout = us,cz
    kb_variant =
    kb_model =
    kb_options = grp:rctrl_toggle,compose:ralt
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = false
	   disable_while_typing = false
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 1
    gaps_out = 2
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 2

    blur {
        enabled = true
        size = 3
        passes = 1
        
        vibrancy = 0.1696
    }

    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = true

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = false
}

misc {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = -1 # Set to 0 to disable the anime mascot wallpapers
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

xwayland {
	force_zero_scaling = true
}
# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
windowrulev2 = nomaximizerequest, class:.* # You'll probably like this.


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

bind = $mainMod, Return, exec, $terminal

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, $terminal
bind = $mainMod+Shift, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, SPACE, togglefloating,
bind = $mainMod, R, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

bind = $mainMod SHIFT, left, swapwindow, l
bind = $mainMod SHIFT, right, swapwindow, r
bind = $mainMod SHIFT, up, swapwindow, u
bind = $mainMod SHIFT, down, swapwindow, d


bind = $mainMod SHIFT ALT, left, movewindow, l
bind = $mainMod SHIFT ALT, right, movewindow, r
bind = $mainMod SHIFT ALT, up, movewindow, u
bind = $mainMod SHIFT ALT, down, movewindow, d



# Switch workspaces with mainMod + [0-9]
bind = $mainMod, F1, workspace, 1
bind = $mainMod, F2, workspace, 2
bind = $mainMod, F3, workspace, 3
bind = $mainMod, F4, workspace, 4
bind = $mainMod, F5, workspace, 5
bind = $mainMod, F6, workspace, 6
bind = $mainMod, F7, workspace, 7
bind = $mainMod, F8, workspace, 8
bind = $mainMod, F9, workspace, 9
bind = $mainMod, F10, workspace, 10
bind = $mainMod, F11, workspace, 11
bind = $mainMod, F12, workspace, 12

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, F1, movetoworkspace, 1
bind = $mainMod SHIFT, F2, movetoworkspace, 2
bind = $mainMod SHIFT, F3, movetoworkspace, 3
bind = $mainMod SHIFT, F4, movetoworkspace, 4
bind = $mainMod SHIFT, F5, movetoworkspace, 5
bind = $mainMod SHIFT, F6, movetoworkspace, 6
bind = $mainMod SHIFT, F7, movetoworkspace, 7
bind = $mainMod SHIFT, F8, movetoworkspace, 8
bind = $mainMod SHIFT, F9, movetoworkspace, 9
bind = $mainMod SHIFT, F10, movetoworkspace, 10
bind = $mainMod SHIFT, F11, movetoworkspace, 11
bind = $mainMod SHIFT, F12, movetoworkspace, 12


binde=, XF86AudioRaiseVolume, exec, wpctl set-volume  @DEFAULT_AUDIO_SINK@ 5%+
bindle=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind=, XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bind=, XF86WLAN, exec, ~/.config/hypr/wifitoggle.sh
bind=, XF86MonBrightnessUp, exec, ~/.config/hypr/backlight.sh inc
bind=, XF86MonBrightnessDown, exec, ~/.config/hypr/backlight.sh dec

bind=, Print, exec,~/.config/hypr/screenshot.sh
bind= $mainMod, L, exec, swaylock -c 000000
bind= $mainMod, S, exec, ~/.config/hypr/suspend.sh

#

# Example special workspace (scratchpad)
#bind = $mainMod SHIFT, S, togglespecialworkspace, magic
#bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, page_up, workspace, e+1
bind = $mainMod, page_down, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow


exec-once = swayidle -w -C $HOME/.config/swayidle/config
exec-once = waybar
exec-once = gentoo-pipewire-launcher restart
exec-once = hyprpaper
exec-once = ~/.config/hypr/randomwp.sh

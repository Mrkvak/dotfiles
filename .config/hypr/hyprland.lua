-- Hyprland Lua config, shared by all machines.
-- Per-machine settings are picked at runtime by hostname (see HOSTS below).
-- See https://wiki.hypr.land/configuring/

-----------------
---- MACHINE ----
-----------------

local function read_hostname()
    local f = io.open("/proc/sys/kernel/hostname")
    if not f then
        return ""
    end
    local h = f:read("l") or ""
    f:close()
    return h
end

local HOSTS = {
    -- work desktop: three 1440p monitors, left to right
    maxhass = {
        profile  = "work",
        monitors = {
            { output = "HDMI-A-1", mode = "2560x1440", position = "0x0",    scale = 1 },
            { output = "DP-1",     mode = "2560x1440", position = "2560x0", scale = 1 },
            { output = "DVI-D-1",  mode = "2560x1440", position = "5120x0", scale = 1 },
        },
        left = "HDMI-A-1", center = "DP-1", right = "DVI-D-1",
    },
    -- notebook
    blackdaemon = {
        profile  = "ntb",
        monitors = {
            { output = "", mode = "highres", position = "auto", scale = 1 },
        },
        left = "eDP-1", center = "eDP-1", right = "eDP-1",
    },
}

-- Unknown host: any monitor, automatic layout, no workspace pinning.
local host = HOSTS[read_hostname()] or {
    profile  = "default",
    monitors = { { output = "", mode = "preferred", position = "auto", scale = "auto" } },
}


------------------
---- MONITORS ----
------------------

for _, m in ipairs(host.monitors) do
    hl.monitor(m)
end

-- Workspaces 1-4 left, 5-8 center, 9-12 right
if host.left then
    for i = 1, 12 do
        local mon
        if i <= 4 then
            mon = host.left
        elseif i <= 8 then
            mon = host.center
        else
            mon = host.right
        end
        hl.workspace_rule({ workspace = tostring(i), monitor = mon })
    end
end


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "foot"
local fileManager = "dolphin"
local menu        = "hyprlauncher --toggle"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("HYPRCURSOR_THEME", "XCursor-Pro-Dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if you have that

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("swayidle -w -C $HOME/.config/swayidle/config")
    hl.exec_cmd("hyprctl setcursor XCursor-Pro-Dark 30")
    hl.exec_cmd("waybar")
    hl.exec_cmd("gentoo-pipewire-launcher restart")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("~/.config/hypr/randomwp.sh")
    hl.exec_cmd("wl-paste -t text --watch clipman store --no-persist")
    hl.exec_cmd("wlsunset -l 51.0 -L 15.0")
    hl.exec_cmd("hyprlauncher --daemon")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    input = {
        kb_layout  = "us,cz",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:rctrl_toggle,compose:ralt",
        kb_rules   = "",

        follow_mouse = 1,

        touchpad = {
            natural_scroll       = false,
            disable_while_typing = false,
        },

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },

    general = {
        gaps_in     = 1,
        gaps_out    = 2,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",

        -- See https://wiki.hypr.land/configuring/extra/tearing/ before turning this on
        allow_tearing = false,
    },

    decoration = {
        rounding = 2,

        blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },

        -- shadow = {
        --     enabled      = true,
        --     range        = 4,
        --     render_power = 3,
        --     color        = 0xee1a1a1a,
        -- },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        -- pseudotile = true,
        preserve_split = true,
    },

    misc = {
        vrr                     = 1,
        force_default_wallpaper = -1, -- Set to 0 to disable the anime mascot wallpapers
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Animation definitions (only used when animations.enabled = true)
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local function key(mods, k)
    if mods == "" then
        return k
    end
    return mods .. " + " .. k
end

hl.bind(key(mainMod, "Return"),          hl.dsp.exec_cmd(terminal))
hl.bind(key(mainMod, "Q"),               hl.dsp.exec_cmd(terminal))
hl.bind(key(mainMod .. " + SHIFT", "C"), hl.dsp.window.close())
hl.bind(key(mainMod .. " + SHIFT", "M"), hl.dsp.exit()) -- shifted so it is hard to hit by accident
hl.bind(key(mainMod, "E"),               hl.dsp.exec_cmd(fileManager))
hl.bind(key(mainMod, "SPACE"),           hl.dsp.window.float({ action = "toggle" }))
hl.bind(key(mainMod, "R"),               hl.dsp.exec_cmd(menu))
hl.bind(key(mainMod, "P"),               hl.dsp.window.pseudo()) -- dwindle
-- hl.bind(key(mainMod, "J"),            hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(key(mainMod, "F"),               hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Focus / swap / move with arrow keys
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(key(mainMod, dir),                     hl.dsp.focus({ direction = dir }))
    hl.bind(key(mainMod .. " + SHIFT", dir),       hl.dsp.window.swap({ direction = dir }))
    hl.bind(key(mainMod .. " + SHIFT + ALT", dir), hl.dsp.window.move({ direction = dir }))
end

-- Switch workspaces with mainMod + F1-F12
-- Move active window to a workspace with mainMod + SHIFT + F1-F12
for i = 1, 12 do
    hl.bind(key(mainMod, "F" .. i),             hl.dsp.focus({ workspace = i }))
    hl.bind(key(mainMod .. " + SHIFT", "F" .. i), hl.dsp.window.move({ workspace = i }))
end

-- Media / hardware keys
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),   { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),  { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86WLAN",              hl.dsp.exec_cmd("~/.config/hypr/wifitoggle.sh"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/hypr/backlight.sh inc"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/backlight.sh dec"))

hl.bind("Print",           hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh"))
hl.bind("SHIFT + Print",   hl.dsp.exec_cmd("~/.config/hypr/screenshot.sh region"))
hl.bind(key(mainMod, "L"), hl.dsp.exec_cmd("pgrep -x swaylock >/dev/null || swaylock -f"))
hl.bind(key(mainMod, "S"), hl.dsp.exec_cmd("~/.config/hypr/suspend.sh"))

-- Example special workspace (scratchpad)
-- hl.bind(key(mainMod .. " + SHIFT", "S"), hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(key(mainMod .. " + SHIFT", "S"), hl.dsp.window.move({ workspace = "special:magic" }))

-- Cycle through existing workspaces
hl.bind(key(mainMod, "page_up"),   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key(mainMod, "page_down"), hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(key(mainMod, "mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key(mainMod, "mouse:273"), hl.dsp.window.resize(), { mouse = true })

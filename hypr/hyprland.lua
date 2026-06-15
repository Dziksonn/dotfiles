-- =============================================================================
-- hyprland.lua — personal config for Hyprland 0.55+
-- Rewritten from hyprlang to Lua. Edit per https://wiki.hypr.land/Configuring/
-- =============================================================================


-- =============================================================================
-- MONITORS
-- =============================================================================

hl.monitor({ output = "DP-1", mode = "1920x1080@144",   position = "0x0",      scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1200@59.95", position = "1920x-100", scale = 1 })


-- =============================================================================
-- PROGRAMS
-- =============================================================================

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "rofi -show drun"
local scriptsMenu = 'rofi -show scripts -modes "scripts:~/.config/rofi/scripts.sh"'
local mainMod     = "SUPER"


-- =============================================================================
-- AUTOSTART
-- =============================================================================

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("clipse -listen")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- hl.exec_cmd("wlsunset -l 50.0642 -L 19.9458 -t 4000:5500:7000")
    hl.exec_cmd("firefox",        { workspace = "1 silent", monitor = "DP-1" })
    hl.exec_cmd("vesktop",        { workspace = "2 silent", monitor = "DP-2" })
    hl.exec_cmd("easyeffects")
    hl.exec_cmd("signal-desktop")
end)


-- =============================================================================
-- ENVIRONMENT VARIABLES
-- =============================================================================

hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")


-- =============================================================================
-- PERMISSIONS
-- See https://wiki.hypr.land/Configuring/Permissions/
-- Changes here require a full Hyprland restart.
-- =============================================================================

-- hl.ecosystem({ enforce_permissions = 1 })
-- hl.permission("/usr/(bin|local/bin)/grim",                                       "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",            "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm",                                     "plugin",     "allow")


-- =============================================================================
-- LOOK AND FEEL
-- =============================================================================

-- Bezier curves
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0,    0 },    { 1,    1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5,  0.5 },  { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1,  1 } } })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default"      })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick"        })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick"        })


-- =============================================================================
-- MAIN CONFIG BLOCK
-- =============================================================================

hl.config({

    -- -------------------------------------------------------------------------
    -- General
    -- -------------------------------------------------------------------------
    general = {
        gaps_in  = 2,
        gaps_out = 2,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(9399B2ee)", "rgba(6C7086ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,   -- see https://wiki.hypr.land/Configuring/Tearing/
        layout           = "dwindle",
    },

    -- -------------------------------------------------------------------------
    -- Decoration
    -- -------------------------------------------------------------------------
    decoration = {
        rounding       = 5,
        rounding_power = 1,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    -- -------------------------------------------------------------------------
    -- Animations — enabled flag only; curves/animations registered above
    -- -------------------------------------------------------------------------
    animations = {
        enabled = true,
    },

    -- -------------------------------------------------------------------------
    -- Layouts
    -- -------------------------------------------------------------------------
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },

    -- -------------------------------------------------------------------------
    -- Misc
    -- -------------------------------------------------------------------------
    misc = {
        force_default_wallpaper = -1,    -- -1 = random; 0 or 1 disables anime mascot
        disable_hyprland_logo   = false, -- set true to remove background logo
    },

    -- -------------------------------------------------------------------------
    -- Input
    -- -------------------------------------------------------------------------
    input = {
        kb_layout  = "pl",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse  = 1,
        accel_profile = "flat",
        sensitivity   = -0.3,   -- range: -1.0 to 1.0; 0 = no modification
        touchpad = {
            natural_scroll = false,
        },
    },

})


-- =============================================================================
-- GESTURES
-- =============================================================================

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


-- =============================================================================
-- PER-DEVICE INPUT
-- =============================================================================

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })


-- =============================================================================
-- WORKSPACE → MONITOR PINNING
-- =============================================================================

for _, ws in ipairs({ 1, 2, 3, 4, 5 }) do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-1" })
end
for _, ws in ipairs({ 6, 7, 8, 9, 10 }) do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-2" })
end

-- Smart gaps (uncomment to enable):
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })


-- =============================================================================
-- KEYBINDINGS
-- =============================================================================

-- Clipboard manager
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(terminal .. " --class clipse -e clipse"))

-- Screenshots
hl.bind(mainMod .. " + S",       hl.dsp.exec_cmd("hyprshot -m region --clipboard-only -z"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only -z"))
hl.bind("Print",                 hl.dsp.exec_cmd("grim - | wl-copy"))

-- Waybar: press/hold SUPER to show, release to hide; SUPER+H to lock visible
hl.bind("SUPER_L", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"),
    { transparent = true, ignore_mods = true, long_press = true })
hl.bind("SUPER_L", hl.dsp.exec_cmd("pkill -SIGUSR2 waybar"),
    { release = true, transparent = true, ignore_mods = true })
hl.bind(mainMod .. " + H",       hl.dsp.exec_cmd("~/.config/hypr/hyprscripts/waybar-lock.sh"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

-- Core actions
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",         hl.dsp.window.close())
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(scriptsMenu))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Move window
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

local function ws_on_current_monitor(n)
    local mon = hl.get_active_monitor()
    local offset = (mon.name == "DP-2") and 5 or 0
    return n + offset
end

for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, function()
        hl.dispatch(hl.dsp.focus({ workspace = ws_on_current_monitor(i) }))
    end)
    hl.bind(mainMod .. " + SHIFT + " .. i, function()
        hl.dispatch(hl.dsp.window.move({ workspace = ws_on_current_monitor(i) }))
    end)
end

-- Special / scratchpad workspace
hl.bind(mainMod .. " + D",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize with mouse drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Volume & brightness (locked = works on lockscreen, repeating = hold to repeat)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Media keys (playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })


-- =============================================================================
-- WINDOW RULES
-- =============================================================================

-- Suppress maximize requests from apps
hl.window_rule({
    match         = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland phantom-focus issues
hl.window_rule({
    match    = { class = "^$", title = "^$", xwayland = true, fullscreen = false},
    no_focus = true,
})

-- Picture-in-Picture: floating, unassigned workspace, keep aspect ratio
hl.window_rule({
    match            = { title = "^(Picture%-in%-Picture)$" },
    workspace        = "unset",
    float            = true,
    keep_aspect_ratio = true,
})

-- Clipse clipboard manager: floating, fixed size, stay focused
hl.window_rule({
    match       = { class = "^(clipse)$" },
    float       = true,
    size        = "1344 756",
    stay_focused = true,
})
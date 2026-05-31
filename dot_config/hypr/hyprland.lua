require("bindings")
require("monitors")
require("apps")
local colors = require("colors")

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("FZF_DEFAULT_COMMAND", "fd . / -u")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border = { colors = { colors.color2, colors.color4, colors.color6 }, angle = 90 },
            inactive_border = colors.background,
        },

        layout = "dwindle",
    },

    decoration = {
        rounding = 0,

        shadow = {
            enabled = true,
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        }
    },

    animations = {
        enabled = true,
    },

    dwindle = {
      preserve_split = true
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
        numlock_by_default = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("overshoot", { type = "bezier", points = { { 0, 0.61 }, { 0.22, 1.12 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "default", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "overshoot" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.8, bezier = "default", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 50, bezier = "default", style = "loop" })

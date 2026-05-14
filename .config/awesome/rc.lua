-- Awesome WM config — mirrors Austin's i3 keybindings, master-stack default.

pcall(require, "luarocks.loader")

local gears     = require("gears")
local awful     = require("awful")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local menubar   = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, errors during startup!",
                     text = awesome.startup_errors })
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Theme
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap   = 8     -- inner gap (i3: gaps inner 8)
beautiful.gap_single_client = false  -- single client = no gap (fullscreen feel)
beautiful.border_width  = 1     -- i3: new_window 1pixel
beautiful.border_normal = "#16161e"
beautiful.border_focus  = "#285577"
beautiful.bg_normal     = "#1a1a2e"
beautiful.bg_focus      = "#285577"
beautiful.fg_normal     = "#e0e0e0"
beautiful.fg_focus      = "#ffffff"
beautiful.font          = "monospace 9"

-- i3bar-like wibar palette
beautiful.wibar_bg          = "#1a1a2e"
beautiful.wibar_fg          = "#a0a0a0"
beautiful.taglist_bg_focus  = "#285577"
beautiful.taglist_fg_focus  = "#ffffff"
beautiful.taglist_bg_urgent = "#900000"
beautiful.taglist_fg_urgent = "#ffffff"
beautiful.taglist_bg_occupied = "#1a1a2e"
beautiful.taglist_fg_occupied = "#ffffff"
beautiful.taglist_bg_empty  = "#1a1a2e"
beautiful.taglist_fg_empty  = "#888888"
beautiful.tasklist_bg_normal = "#1a1a2e"
beautiful.tasklist_fg_normal = "#a0a0a0"
beautiful.tasklist_bg_focus  = "#1a1a2e"
beautiful.tasklist_fg_focus  = "#ffffff"
beautiful.tasklist_align     = "center"

-- Defaults
local terminal   = "ghostty"
local editor     = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor
local modkey     = "Mod4"

-- Layouts — master-stack only
awful.layout.layouts = {
    awful.layout.suit.tile,            -- master-stack (only)
}

-- Wibar: per-screen taglist + tasklist + clock
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then c.minimized = true
        else c:emit_signal("request::activate", "tasklist", { raise = true }) end
    end),
    awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end)
)

local mytextclock = wibox.widget.textclock(
    "<span foreground='#ffffff'> %a %b %d  %H:%M </span>")

local function sep()
    return wibox.widget({
        markup = "<span foreground='#666666'> | </span>",
        widget = wibox.widget.textbox,
    })
end

awful.screen.connect_for_each_screen(function(s)
    -- Tags 1..10 named like i3 workspaces
    local tags = awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, s, awful.layout.layouts[1])
    for _, t in ipairs(tags) do
        t.gap_single_client = false
    end

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })
    s.mytasklist = awful.widget.tasklist({
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 22, bg = beautiful.wibar_bg, fg = beautiful.wibar_fg })
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { layout = wibox.layout.fixed.horizontal, s.mytaglist, s.mypromptbox },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            sep(),
            mytextclock,
            sep(),
            s.mylayoutbox,
        },
    })
end)

-- Resize mode (i3 mode "resize" — t/k/l/n + arrows)
local resize_step = 0.02
local function resize_mode()
    return awful.keygrabber.run(function(_, key, event)
        if event ~= "press" then return end
        if key == "t" or key == "Left" then
            awful.tag.incmwfact(-resize_step)
        elseif key == "n" or key == "Right" then
            awful.tag.incmwfact(resize_step)
        elseif key == "k" or key == "Down" then
            awful.client.incwfact(resize_step)
        elseif key == "l" or key == "Up" then
            awful.client.incwfact(-resize_step)
        elseif key == "Return" or key == "Escape" or key == "r" then
            awful.keygrabber.stop()
        end
    end)
end

-- Global keys
local globalkeys = gears.table.join(
    -- Help
    awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

    -- Launch (i3: Mod+Return / Mod+Shift+Return)
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
        { description = "open terminal", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "Return", function() awful.spawn({ "rofi", "-show", "combi", "-modes", "combi", "-combi-modes", "drun,run" }) end,
        { description = "app launcher (rofi)", group = "launcher" }),

    -- Kill (i3: Mod+Shift+c)
    awful.key({ modkey, "Shift" }, "c", function() if client.focus then client.focus:kill() end end,
        { description = "kill focused", group = "client" }),

    -- Focus (i3: j/h = left, k/l = right)
    awful.key({ modkey }, "j", function() awful.client.focus.byidx(-1) end,
        { description = "focus prev", group = "client" }),
    awful.key({ modkey }, "h", function() awful.client.focus.byidx(-1) end,
        { description = "focus prev", group = "client" }),
    awful.key({ modkey }, "k", function() awful.client.focus.byidx(1) end,
        { description = "focus next", group = "client" }),
    awful.key({ modkey }, "l", function() awful.client.focus.byidx(1) end,
        { description = "focus next", group = "client" }),
    awful.key({ modkey }, "Left",  function() awful.client.focus.global_bydirection("left")  end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "Right", function() awful.client.focus.global_bydirection("right") end,
        { description = "focus right", group = "client" }),
    awful.key({ modkey }, "Up",    function() awful.client.focus.global_bydirection("up")    end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey }, "Down",  function() awful.client.focus.global_bydirection("down")  end,
        { description = "focus down", group = "client" }),

    -- Move (i3: Shift+j/h = left, Shift+k/l = right)
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(-1) end,
        { description = "swap prev", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.byidx(-1) end,
        { description = "swap prev", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(1) end,
        { description = "swap next", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.byidx(1) end,
        { description = "swap next", group = "client" }),
    awful.key({ modkey, "Shift" }, "Left",  function()
        if client.focus then awful.client.swap.global_bydirection("left")  end end,
        { description = "move left", group = "client" }),
    awful.key({ modkey, "Shift" }, "Right", function()
        if client.focus then awful.client.swap.global_bydirection("right") end end,
        { description = "move right", group = "client" }),
    awful.key({ modkey, "Shift" }, "Up",    function()
        if client.focus then awful.client.swap.global_bydirection("up")    end end,
        { description = "move up", group = "client" }),
    awful.key({ modkey, "Shift" }, "Down",  function()
        if client.focus then awful.client.swap.global_bydirection("down")  end end,
        { description = "move down", group = "client" }),

    -- Layout — master-stack only, force on demand
    awful.key({ modkey }, "e", function() awful.layout.set(awful.layout.suit.tile) end,
        { description = "force master-stack", group = "layout" }),

    -- Floating + focus toggles (i3: Shift+space, space)
    awful.key({ modkey }, "space", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end, { description = "focus prev (mode toggle)", group = "client" }),

    -- Reload / restart / exit (i3: Shift+g reload, Shift+r restart, Shift+e exit)
    awful.key({ modkey, "Shift" }, "g", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        { description = "restart awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "e", awesome.quit,
        { description = "quit awesome", group = "awesome" }),

    -- Resize mode (i3: Mod+r)
    awful.key({ modkey }, "r", function() resize_mode() end,
        { description = "resize mode", group = "client" }),

    -- Quick resize (no mode)
    awful.key({ modkey, "Shift" }, "t", function() awful.tag.incmwfact(-resize_step) end,
        { description = "shrink master", group = "client" }),
    awful.key({ modkey, "Shift" }, "n", function() awful.tag.incmwfact(resize_step) end,
        { description = "grow master", group = "client" }),

    -- Screenshot (i3: Mod+o)
    awful.key({ modkey }, "o", function() awful.spawn("flameshot gui") end,
        { description = "flameshot", group = "launcher" }),

    -- Volume / media
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +10%") end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -10%") end),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end),
    awful.key({}, "XF86AudioMicMute", function()
        awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end),
    awful.key({}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end),
    awful.key({}, "XF86AudioNext", function() awful.spawn("playerctl next") end),
    awful.key({}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end)
)

-- Tag (workspace) keys 1..0
for i = 1, 10 do
    local key = (i == 10) and "#19" or ("#" .. i + 9)  -- #10..#18 = 1..9, #19 = 0
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, key, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                if tag == screen.selected_tag then
                    awful.tag.history.restore(screen, 1)
                else
                    tag:view_only()
                end
            end
        end, { description = "view tag " .. i .. " (toggle back if current)", group = "tag" }),
        awful.key({ modkey, "Shift" }, key, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end, { description = "move to tag " .. i, group = "tag" })
    )
end

-- Per-client keys
local clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
        { description = "fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "space", function(c) c.floating = not c.floating end,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey }, "a", function(c) c:emit_signal("request::activate", "key.unminimize", {raise=true}) end,
        { description = "focus parent (no-op)", group = "client" })
)

local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise=true}) end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise=true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise=true})
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)

-- Rules
awful.rules.rules = {
    { rule = {},
      properties = {
          border_width     = beautiful.border_width,
          border_color     = beautiful.border_normal,
          focus            = awful.client.focus.filter,
          raise            = true,
          keys             = clientkeys,
          buttons          = clientbuttons,
          screen           = awful.screen.preferred,
          placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
          titlebars_enabled = false,
      },
    },
    { rule_any = { type = { "dialog" }, class = { "Pavucontrol" } },
      properties = { floating = true } },
}

-- Signals
client.connect_signal("manage", function(c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
    if not awesome.startup then awful.client.setslave(c) end
end)

-- focus_follows_mouse (i3: yes)
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart (mirror i3 execs)
local function run_once(cmd)
    local fname = cmd:match("([^%s]+)")
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s >/dev/null || (%s &)", fname, cmd))
end

run_once("nm-applet")
run_once("dex --autostart --environment awesome")
awful.spawn.with_shell("xset s off -dpms")
run_once("xss-lock --transfer-sleep-lock -- i3lock --nofork")

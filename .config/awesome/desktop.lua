-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require('shifty')
require('vicious')
require('notmuch')
-- Theme handling library
require("beautiful")
beautiful.init("/home/pazz/.config/awesome/themes/pazz/theme.lua")
-- Notification library
require("naughty")
--calendar
require('calendar2')
require('notmuchhoover')
require('weatherhoover')

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
lock_cmd = "xtrlock"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
irc_cmd = terminal .. " -T irssi -e ssh -X pazz@0x7fffffff.net"
mpd_cmd = terminal .. " -T ncmpc -e ncmpc -c"
--mixer_cmd = terminal .. " -T alsamixer -e alsamixer"
mixer_cmd = "pavucontrol"
mail_cmd = 'urxvt -T alot -e alot'
--mail_cmd = 'urxvt -T sup -e sup'
gmail_cmd = 'urxvt -T mutt -e mutt -F ~/.muttrc.gmail'

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

--{{{ SHIFTY: configured tags
shifty.config.tags = {
    ["sys"] = { 
        mwfact = 0.65,
        icon=beautiful.tag_sys,
        position = 1, 
        init = false,
    },
    ["edit"] = { 
        mwfact = 0.65,
        position = 2, 
        icon=beautiful.tag_edit,
        spawn = terminal
    },
    ["web"] = { 
        mwfact = 0.65,
        position = 3, 
        init = false,
        icon=beautiful.tag_web,
        spawn = 'firefox' 
    },
    ["fm"] = { 	
        mwfact = 0.65,
        position = 4, 
        init = false,
        spawn = 'thunar' 
    },
    ["media"] = { 	
        mwfact = 0.65,
        position = 5, 
        init = false,
        spawn = mpd_cmd
    },
    ["docs"] = { 	
        mwfact = 0.65,
        position = 5, 
        init = false,
        screen = math.max(screen.count(), 2)
    },
    ["bib"] = { 	
        position = 6, 
        init = false,
        spawn = 'jabref -s',
        icon= beautiful.tag_bib,
    },
    ["calendar"] = {  
        spawn="firefox -safe-mode -new-window http://calendar.google.com",
        icon= beautiful.tag_cal,
        position = 7,
    },
    ["mail"] = { 
        mwfact = 0.55,
        position = 8, 
        init = false,
        icon=beautiful.tag_mail,
        spawn = mail_cmd, 
    },
    ["im"] = { 	
        layout = awful.layout.suit.tile, 
        mwfact = 0.85, 
        icon=beautiful.tag_im,
        position = 9, 
        spawn = "pidgin & " ..irc_cmd,
        },
}
--}}}
 
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ }, 8, function (c) c:kill() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
--{{{ SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
         { match = { "Firefox" }, tag = "web" } ,
         --{ match = { ".*alendar" } , tag = {"calendar"} } ,
         { match = { "Shredder.*","Thunderbird","mutt", "alot" } , tag = "mail" } ,
         { match = { "MPlayer", "Gnuplot", "galculator" } , float = true } ,
         { match = { terminal } ,slave = true } ,
         { match = { "Pidgin" } ,nopopup=true, honorsizehints = true, slave = true, tag='im'} ,
         { match = { "mupdf" } ,nopopup=true, honorsizehints = true, slave = true} ,
         { match = { "irssi" } ,nopopup=true, honorsizehints = true, slave = false, tag='im'} ,
         { match = { "Quodlibet", "ncmpc", "pavucontrol" } ,tag='media'} ,
         { match = { "zathura", "evince" } ,tag='docs'} ,
         { match = { "" } , buttons = clientbuttons },
}
--}}}

--{{{ SHIFTY: default tag creation rules
-- parameter description
-- * floatBars : if floating clients should always have a titlebar
-- * guess_name : wether shifty should try and guess tag names when creating new (unconfigured) tags
-- * guess_position: as above, but for position parameter
-- * run : function to exec when shifty creates a new tag
-- * remember_index: ?
-- * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults={
  layout = awful.layout.suit.tile,
  ncol = 1,
  mwfact = 0.60,
  floatBars=true,
  guess_name=false,
  guess_position=true,
  leave_kills=true,
}
----}}}

grey = "#404040"
bgrey = "#555753"
red = "#CC0000"
bred = "#EF2929"
green = "#4E9A06"
bgreen = "#8AE234"
yellow = "#C4A000"
byellow = "#FCE94F"
blue = "#195089"
bblue = "#729FCF"
purple = "#75507B"
bpurple = "#AD7FAB"
cyan = "#16A8AA"
bcyan = "#34E2E2"

-- }}}

-- {{{ Functions
-- Set foreground text to predefined color
local function fg(color, text) return '<span color="' .. color .. '">' .. text .. '</span>' end 


-- {{{ Widgets
spacer = widget({ type = "textbox"})
leftcap = widget({ type = "textbox"})
midcap = widget({ type = "textbox"})
rightcap = widget({ type = "textbox"})

spacer.text= "      "
leftcap.text = fg(grey, "") 
midcap.text = fg(grey, " ")
rightcap.text = fg(grey, "")
-- Create a textclock widget
--mytextclock = awful.widget.textclock({ align = "right" })
mytextclock = widget({ type = "textbox" })
vicious.register(mytextclock, vicious.widgets.date, "%b %d, %R")
calendar2.addCalendarToWidget(mytextclock)

-- Create a systray
mysystray = widget({ type = "systray" })

-- CPU widget
cpuicon = widget({type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu_lo)
cpuwidget = widget({ type = "textbox" })
cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_height(17)
cpuwidget:set_background_color(beautiful.bg_normal)
cpuwidget:set_color("#FF5656")
cpuwidget:set_gradient_colors({ "#AEC6D8", "#285577", "#285577" })
cpubuttons = awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn(terminal .. ' -e htop') end),
	awful.button({ }, 3, function () awful.util.spawn('samsung-tools -q -n -c cycle') end)
)
cpuwidget.widget:buttons(cpubuttons)
cpuicon:buttons(cpubuttons)
vicious.register(cpuwidget, vicious.widgets.cpu,
function (widget, args)
	if args[1] >= 40 and args[1] < 80 then
		cpuicon.image = image(beautiful.widget_cpu_mid)
	elseif args[1] >= 80 then
		cpuicon.image = image(beautiful.widget_cpu_hi)
	else
		cpuicon.image = image(beautiful.widget_cpu_lo)
	end
	return args[1]
end, 1 )

-- notmuch
mailicon = widget({ type = 'imagebox', name = 'mailicon'})
mailtext = widget({ type = "textbox" })
querystring = "is:inbox and tag:unread and not tag:killed"
vicious.register(mailtext, vicious.contrib.notmuch, 
function (widget, args)
    if args["count"] > 0 then
            mailicon.image = image(beautiful.widget_mail)
    else
            mailicon.image = image(beautiful.widget_nomail)
    end
    return nil
end,
10, querystring)
mailbuttons = awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn("urxvt -T alot -e alot search "..querystring) end),
  awful.button({ }, 3, function () awful.util.spawn("notmuch tag +killed '"..querystring.."'") end)
)
mailicon:buttons(mailbuttons)
notmuchhoover.addToWidget(mailicon, querystring, 30)

-- alsa
sndicon = widget({ type = "imagebox" })
volbar  = awful.widget.progressbar({layout = awful.widget.layout.horizontal.rightleft})
volbar:set_width(8)
volbar:set_height(17)
volbar:set_vertical(true)
volbar:set_background_color(beautiful.bg_normal)
volbar:set_color("#494B4F")
mute = false
volicon = nil
vicious.register(volbar, vicious.widgets.volume, 
function (widget, args)
        mute = args[2] == "♩"
        if mute then
		volicon = image(beautiful.widget_speaker_mute)
        elseif args[1] >= 50 then
		volicon = image(beautiful.widget_speaker_2)
        else
		volicon = image(beautiful.widget_speaker_1)
	end
	return args[1]
end,
 1, "Master")
volbuttons = awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn(mixer_cmd) end),
	awful.button({ }, 3, function () awful.util.spawn('amixer -q set Master toggle') end),
	awful.button({ }, 4, function () awful.util.spawn('amixer -q set Master 5%+') end),
	awful.button({ }, 5, function () awful.util.spawn('amixer -q set Master 5%-') end)
)
volbar.widget:buttons(volbuttons)
sndicon:buttons(volbuttons)
mpdbuttons = awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn(mpd_cmd) end),
	awful.button({ }, 2, function () awful.util.spawn('mpc -q stop') end),
	awful.button({ }, 3, function () awful.util.spawn('mpc -q toggle') end),
	awful.button({ }, 4, function () awful.util.spawn('mpc -q prev') end),
	awful.button({ }, 5, function () awful.util.spawn('mpc -q next') end)
)
mpdicon = widget({ type = "imagebox" })
mpdicon:buttons(mpdbuttons)
mpdwidget = widget({ type = "textbox" }) --display now playing song
mpdwidget:buttons(mpdbuttons)
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
	    sndicon.image = volicon
	    mpdicon.image = nil
          return
        else
          if mute then
	    sndicon.image = image(beautiful.widget_speaker_mute)
          else
	    sndicon.image = nil
          end
          if args["{state}"] == "Play" then 
	    mpdicon.image = image(beautiful.widget_play)
	  elseif args["{state}"] == "Pause" then
	    mpdicon.image = image(beautiful.widget_pause)
          end
	  return args["{Artist}"] ..' - '.. args["{Title}"]
        end
    end, 1)


-- Weather widget
weatherwidget = widget({ type = "textbox" })
weatherhoover.addToWidget(weatherwidget, 'EGPH')
weatherwidget.text = "weather"
    vicious.register(weatherwidget, vicious.widgets.weather,
    function (widget, args)
        return args["{tempc}"] .. "°C" 
    end, 300, "EGPH" )


 --Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mytextclock or nil,
        s == 1 and spacer or nil,
        s == 1 and rightcap or nil,
        s == 1 and weatherwidget or nil,
        s == 1 and leftcap or nil,
        s == 1 and spacer or nil,

        s == 1 and mysystray or nil,
        s == 1 and spacer or nil,

        s == 1 and rightcap or nil,
        s == 1 and mailicon or nil,
        s == 1 and midcap or nil,
        s == 1 and mailtext or nil,
        s == 1 and leftcap or nil,
        s == 1 and spacer or nil,

        s == 1 and rightcap or nil,
        s == 1 and cpuwidget.widget or nil,
        s == 1 and cpuicon or nil,
        s == 1 and leftcap or nil,
        s == 1 and spacer or nil,

        s == 1 and rightcap or nil,
        s == 1 and mpdwidget or nil,
        s == 1 and midcap or nil,
        s == 1 and volbar.widget or nil,
        s == 1 and mpdicon or nil,
        s == 1 and sndicon or nil,
        s == 1 and leftcap or nil,
        s == 1 and spacer or nil,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

function focus_next()
    awful.client.focus.byidx( 1)
    if client.focus then client.focus:raise() end
end
function focus_prev()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end
function toggle_statusbar()
    if mywibox[mouse.screen].screen == nil then
      mywibox[mouse.screen].screen = mouse.screen
    else
      mywibox[mouse.screen].screen = nil
    end
end
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,            }, "Tab", focus_next),
    awful.key({ modkey, "Shift",   }, "Tab", focus_prev),
    awful.key({ modkey            }, "t",           function() shifty.add({ rel_index = 1 }) end),
    awful.key({ modkey, "Shift" }, "t",           function() shifty.add({ rel_index = 1, nopopup = true }) end),
    awful.key({ modkey            }, "s",           shifty.rename),
    awful.key({ modkey            }, "d",           shifty.del),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () 
        --awful.util.spawn('urxvt -T ' .. awful.tag.getproperty(shifty.getpos(i),"position")) 
        awful.util.spawn(terminal) 
    end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- multimedia and fn keys
    awful.key({}, "XF86Launch1", function () awful.util.spawn('samsung-tools -b toggle') end),
    awful.key({}, "XF86Display", function () awful.util.spawn('toggleDisplays.sh') end),
    awful.key({}, "XF86Launch2", function () awful.util.spawn('samsung-tools -n -w toggle') end),
    awful.key({}, "XF86Launch3", function () awful.util.spawn('samsung-tools -n -c cycle') end),
    --awful.key({}, "XF86Battery", function () awful.util.spawn('samsung-scripts ') end),
    awful.key({}, "XF86WLAN", function () awful.util.spawn('samsung-tools -n -W toggle') end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn('amixer -q set Master toggle') end),
    --awful.key({}, "XF86AudioRaiseVolume", function () alsaw:raise() end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn('amixer -q set Master 5%+') end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn('amixer -q set Master 5%-') end),
    awful.key({}, "XF86MonBrightnessUp", function () awful.util.spawn('xbacklight +15') end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, 	  }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "j",     function (c) awful.client.incwfact(0.05,c)  end),
    awful.key({ modkey,           }, "k",     function (c) awful.client.incwfact(-0.05,c)  end),
    awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

--clientbuttons = awful.util.table.join(
--    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
--    awful.button({ modkey }, 1, awful.mouse.client.move),
--    awful.button({ modkey }, 3, awful.mouse.client.resize))

for i=1,9 do
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey }, i,
  function ()
    local t = awful.tag.viewonly(shifty.getpos(i))
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control" }, i,
  function ()
    local t = shifty.getpos(i)
    t.selected = not t.selected
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control", "Shift" }, i,
  function ()
    if client.focus then
      awful.client.toggletag(shifty.getpos(i))
    end
  end))
  -- move clients to other tags
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Shift" }, i,
    function ()
      if client.focus then
        local t = shifty.getpos(i)
        awful.client.movetotag(t)
        awful.tag.viewonly(t)
      end
    end))
end

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
    
    -- seems to be needed to avoid gaps
    c.size_hints_honor = false

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--

naughty.config.presets.normal.timeout     = 15
naughty.config.presets.critical.timeout     = 15
naughty.config.presets.critical.bg     = beautiful.fg_urgent or '#535d6c'
naughty.config.screen = screen.count()

os.execute("system-config-printer-applet & > /dev/null 2> /dev/null")
os.execute("xset b 0 s 0 -dpms&")
--os.execute("offlineimap -u Noninteractive.Quiet&")

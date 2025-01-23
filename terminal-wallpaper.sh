#!/bin/bash

# Wait for desktop to load
sleep 5

# Kill any existing instances
killall xwinwrap 2>/dev/null
sleep 1

# External monitor (HDMI-1-0)
xwinwrap -g "2560x1440"+0+0 -ni -s -nf -b -ov -argb -- kitty --class="wallpaper_hdmi" --start-as=minimized --title="wallpaper_hdmi" -e bash -c "while true; do btop; done" &

sleep 2

# Laptop screen (eDP-1)
xwinwrap -g "1920x1080"+969+1440 -ni -s -nf -b -ov -argb -- kitty --class="wallpaper_edp" --start-as=minimized --title="wallpaper_edp" -e bash -c "while true; do btop; done" &



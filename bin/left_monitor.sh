#!/bin/sh
xrandr --output DP3 --off --output eDP1 --mode 1440x900 --pos 2560x872 --rotate normal --output DP1 --mode 2560x1440 --pos 0x0 --rotate normal --output DP2 --off --output HDMI3 --off --output HDMI2 --off --output HDMI1 --off --output VGA1 --off && xmodmap ~/.Xmodmap

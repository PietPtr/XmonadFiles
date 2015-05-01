#!/bin/bash

xsetroot -cursor_name arrow
xrandr --output DVI-D-0 --primary --output DVI-I-0 --right-of DVI-D-0
compton &
~/.fehbg 
urxvtd &
xset fp+ /usr/share/fonts/ &
redshift &
xrdb .Xresources &
setxkbmap -layout gb &
xbindkeys
xmobar &
deja-dup --backup &
dunst &
disown

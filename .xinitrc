#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Set background image with feh
feh --bg-scale /home/severus/Pictures/black_panther.jpg &

# Set cursor
xsetroot -cursor_name left_ptr &

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login


#Start xbindkeys Demon
xbindkeys &

#Start Xmonad Window Manager
#exec terminator &
exec ibus-daemon &
exec compton &
exec redshift  -l 12.8996230:77.4826980 &
#exec xscreensaver &
#/home/severus/lightsOn.sh &
exec xmonad
#exec startxfce4

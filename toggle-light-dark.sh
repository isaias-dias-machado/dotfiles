#!/bin/bash
current=$(xfconf-query -c xsettings -p /Net/ThemeName)

if [[ "$current" == *dark* || "$current" == *Dark* ]]; then
    # → switch to LIGHT
    xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
    xfconf-query -c xfwm4 -p /general/theme -s "Adwaita"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
else
    # → switch to DARK
    xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
    xfconf-query -c xfwm4 -p /general/theme -s "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
fi

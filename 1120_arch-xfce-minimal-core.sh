#!/bin/bash
#set -e
##################################################################################################################
#tput setaf 0 = black 
#tput setaf 1 = red 
#tput setaf 2 = green
#tput setaf 3 = yellow 
#tput setaf 4 = dark blue 
#tput setaf 5 = purple
#tput setaf 6 = cyan 
#tput setaf 7 = gray 
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

echo
tput setaf 2
echo "########################################################################"
echo "################### Install XFCE4 minimal Core Software"
echo "########################################################################"
tput sgr0
echo

#settings
sudo pacman -S --noconfirm --needed yuku-dot-files-git yuku-sddm-simplicity-git yuku-flat-remix-dark-git
#sudo pacman -S --noconfirm --needed edu-shells-git edu-xfce-git

#theming
sudo pacman -S --noconfirm --needed arc-gtk-theme hardcode-fixer-git
#sudo pacman -S --noconfirm --needed surfn-icons-git

#tools
sudo pacman -S --noconfirm --needed archlinux-logout-git arandr catfish dmenu galculator networkmanager network-manager-applet networkmanager-openvpn numlockx pavucontrol playerctl xcolor xorg-xkill gparted
#sudo pacman -S --noconfirm --needed nitrogen

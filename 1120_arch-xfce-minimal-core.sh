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

echo
tput setaf 2
echo "########################################################################"
echo "################### Install XFCE4 minimal Core Software"
echo "########################################################################"
tput sgr0
echo

#settings
#sudo pacman -S --noconfirm --needed yuku-dot-files-git
#sudo pacman -S --noconfirm --needed yuku-sddm-simplicity-git
#sudo pacman -S --noconfirm --needed yuku-flat-remix-dark-git
#sudo pacman -S --noconfirm --needed edu-shells-git
#sudo pacman -S --noconfirm --needed edu-xfce-git

#theming
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed surfn-icons-git
sudo pacman -S --noconfirm --needed hardcode-fixer-git

#tools
sudo pacman -S --noconfirm --needed archlinux-logout-git
sudo pacman -S --noconfirm --needed arandr
sudo pacman -S --noconfirm --needed catfish
sudo pacman -S --noconfirm --needed dmenu
sudo pacman -S --noconfirm --needed galculator
sudo pacman -S --noconfirm --needed networkmanager
sudo pacman -S --noconfirm --needed network-manager-applet
sudo pacman -S --noconfirm --needed networkmanager-openvpn
sudo pacman -S --noconfirm --needed nitrogen
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed pavucontrol
sudo pacman -S --noconfirm --needed playerctl
sudo pacman -S --noconfirm --needed xcolor
sudo pacman -S --noconfirm --needed xorg-xkill
sudo pacman -S --noconfirm --needed gparted

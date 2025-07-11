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
echo "################### Core software"
echo "########################################################################"
tput sgr0
echo
sudo pacman -S --noconfirm --needed edu-rofi-git
sudo pacman -S --noconfirm --needed edu-rofi-themes-git

# All the software below will be installed on all desktops
sudo pacman -S --noconfirm --needed archlinux-tools
sudo pacman -S --noconfirm --needed dconf-editor
sudo pacman -S --noconfirm --needed devtools
sudo pacman -S --noconfirm --needed hardinfo2
sudo pacman -S --noconfirm --needed hw-probe
sudo pacman -S --noconfirm --needed logrotate
sudo pacman -S --noconfirm --needed lsb-release
sudo pacman -S --noconfirm --needed powertop
sudo pacman -S --noconfirm --needed inxi
sudo pacman -S --noconfirm --needed acpi
sudo pacman -S --noconfirm --needed plocate
sudo pacman -S --noconfirm --needed most
sudo pacman -S --noconfirm --needed namcap
sudo pacman -S --noconfirm --needed nomacs
sudo pacman -S --noconfirm --needed nm-connection-editor
sudo pacman -S --noconfirm --needed python-pylint
sudo pacman -S --noconfirm --needed python-pywal


tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
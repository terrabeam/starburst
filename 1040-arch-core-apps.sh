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
sudo pacman -S --noconfirm --needed archlinux-tools dconf-editor devtools hardinfo2 hw-probe logrotate lsb-release powertop inxi acpi plocate most namcap nm-connection-editor python-pylint python-pywal
#sudo pacman -S --noconfirm --needed nomacs

tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
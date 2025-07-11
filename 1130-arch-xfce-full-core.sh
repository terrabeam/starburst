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
echo "################### Install XFCE4 Full Core Software"
echo "########################################################################"
tput sgr0
echo

#internet
sudo pacman -S --noconfirm --needed chromium


echo
tput setaf 2
echo "########################################################################"
echo "################### Configure XFCE4-settings"
echo "########################################################################"
tput sgr0
echo

echo
echo "Setting Default Applications"
echo
sudo cp -rf $installed_dir/assets/xfce4/ /etc/skel/.config/
sudo cp $installed_dir/assets/mimeapps.list /etc/skel/.config/mimeapps.list

echo
echo "Setting bashrc"
echo
sudo cp -v /etc/skel/.bashrc /etc/skel/.bashrc.starburst
sudo cp -rf $installed_dir/assets/.bashrc /etc/skel/.bashrc

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
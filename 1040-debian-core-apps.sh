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
echo "################### Core software"
echo "########################################################################"
tput sgr0
echo

# All the software below will be installed on all desktops
sudo apt install -y dconf-editor build-essential hardinfo hw-probe logrotate lsb-release powertop inxi acpi plocate most network-manager-gnome python3-pylint python3-pywal

tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
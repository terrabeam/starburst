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
tput setaf 3
echo "################################################################"
echo "################### Select Desktop Environment / Window Manager"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 3
echo "########################################################################"
echo "Which desktop environment do you want to install?"
echo "Choose one of the following options:"
echo
echo "1) XFCE4 minimal"
echo "2) XFCE4 full"
echo "3) XFCE4 workstation"
echo "4) Plasma minimal"
echo "5) Plasma full"
echo "X) None"
echo "########################################################################"
tput sgr0
echo

read -r -p "Enter the number of your choice: " choice

case "$choice" in
    1)
        touch /tmp/install-xfce4-minimal
        ;;
    2)
        touch /tmp/install-xfce4-full
        ;;
    3)
        touch /tmp/install-xfce4-workstation
        ;;
    4)
        touch /tmp/install-plasma-minimal
        ;;
    %)
        touch /tmp/install-plasma-full
        ;;
    [Xx])
        echo "No desktop environment will be installed."
        ;;
    *)
        tput setaf 1
        echo "Invalid choice. Exiting."
        tput sgr0
        exit 1
        ;;
esac

echo
tput setaf 3
echo "########################################################################"
echo "Would you like to install an additional Tiling Window Manager?"
echo "Choose one of the following options:"
echo
echo "1) CHADWM"
echo "2) Hyprland (not possible on VM)"
echo "X) None"
echo "########################################################################"
tput sgr0
echo

read -p "Enter the number of your choice: " choice

case "$choice" in
    1)
        touch /tmp/install-chadwm
        ;;
    2)
        touch /tmp/install-hyprland
        ;;
    [Xx])
        echo "No desktop environment will be installed."
        ;;
    *)
        tput setaf 1
        echo "Invalid choice. Exiting."
        tput sgr0
        exit 1
        ;;
esac

tput setaf 3
echo "################################################################"
echo "Starting installation of chosen Desktop Environment"
echo "################################################################"
tput sgr0

if [ -f /tmp/install-xfce4-minimal ]; then
    sh 1020-arch-remove-apps*
    sh 1030-arch-base*
    sh 1110-arch-xfce-minimal*
    sh 1120_arch-xfce-minimal-core*
fi

if [ -f /tmp/install-xfce4-full ]; then
    sh 1020-arch-remove-apps*
    sh 1030-arch-base*
    sh 1110-arch-xfce-minimal*
    sh 1120_arch-xfce-minimal-core*
    sh 1130-arch-xfce-full-core*
fi

if [ -f /tmp/install-xfce4-workstation ]; then
    sh 1020-arch-remove-apps*
    sh 1030-arch-base*
    sh 1110-arch-xfce-minimal*
    sh 1120_arch-xfce-minimal-core*
    sh 1130-arch-xfce-full-core*
    sh 1140-arch-xfce-full-ws*
fi

if [ -f /tmp/install-plasma-minimal ]; then
    sh 1110-arch-plasma-minimal*
fi

if [ -f /tmp/install-plasma-full ]; then
    sh 1110-arch-plasma-minimal*
    sh 1110-arch-plasma-full*
fi

# installation of Tiling Window Managers
if [ -f /tmp/install-chadwm ]; then
    sh 1200-arch-chadwm*
fi

if [ -f /tmp/install-hyprland ]; then
    sh 1120-arch-hyprland*
fi

tput setaf 3
echo "################################################################"
echo "End Arch setup"
echo "################################################################"
tput sgr0

tput setaf 3
echo "################################################################"
echo "Cleaning up"
echo "################################################################"
tput sgr0

rm -f /tmp/install-*

### Run final scripts
sh 9990-skel.sh

### DONE
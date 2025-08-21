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

if grep -qi "arch" /etc/os-release; then
    OS="arch"
elif grep -qi "debian" /etc/os-release; then
    OS="debian"
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

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
        touch /tmp/install-xfce4-minimal-$OS
        ;;
    2)
        touch /tmp/install-xfce4-full-$OS
        ;;
    3)
        touch /tmp/install-xfce4-workstation-$OS
        ;;
    4)
        touch /tmp/install-plasma-minimal-$OS
        ;;
    5)
        touch /tmp/install-plasma-full-$OS
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

if [ -f /tmp/install-xfce4-minimal-arch ]; then
    sh 1020-arch*
    sh 1030-arch*
    sh 1040-arch-*
    sh 1110-xfce*
    sh 1120-xfce*
elif [ -f /tmp/install-xfce4-minimal-debian ]; then
    sh 1020-debian*
    sh 1030-debian*
    sh 1040-debian-*
    sh 1110-xfce*
    sh 1120-xfce*
fi

if [ -f /tmp/install-xfce4-full-arch ]; then
    sh 1020-arch*
    sh 1030-arch*
    sh 1040-arch-*
    sh 1110-arch-xfce*
    sh 1120_arch-xfce*
    sh 1130-arch-xfce*
fi
elif [ -f /tmp/install-xfce4-full-debian ]; then
    sh 1020-debian*
    sh 1030-debian*
    sh 1040-debian-*
    sh 1110-debian-xfce*
    sh 1120_debian-xfce*
    sh 1130-debian-xfce*
fi

if [ -f /tmp/install-xfce4-workstation-arch ]; then
    sh 1020-arch-*
    sh 1030-arch-*
    sh 1040-arch-*
    sh 1110-arch-xfce*
    sh 1120_arch-xfce*
    sh 1130-arch-xfce*
    sh 1140-arch-xfce*
fi
elif [ -f /tmp/install-xfce4-workstation-debian ]; then
    sh 1020-debian-*
    sh 1030-debian-*
    sh 1040-debian-*
    sh 1110-debian-xfce*
    sh 1120_debian-xfce*
    sh 1130-debian-xfce*
    sh 1140-debian-xfce*
fi

if [ -f /tmp/install-plasma-minimal-arch ]; then
    sh 1110-arch-plasma-minimal*
fi
elif [ -f /tmp/install-plasma-minimal-debian ]; then
    sh 1110-debian-plasma-minimal*
fi

if [ -f /tmp/install-plasma-full-arch ]; then
    sh 1110-arch-plasma-minimal*
    sh 1110-arch-plasma-full*
fi
elif [ -f /tmp/install-plasma-full-debian ]; then
    sh 1110-debian-plasma-minimal*
    sh 1110-debian-plasma-full*
fi

# installation of Tiling Window Managers
if [ -f /tmp/install-chadwm-arch ]; then
    sh 1200-arch-chadwm*
fi
elif [ -f /tmp/install-chadwm-debian ]; then
    sh 1200-debian-chadwm*
fi

if [ -f /tmp/install-hyprland-arch ]; then
    sh 1120-arch-hyprland*
fi
elif [ -f /tmp/install-hyprland-debian ]; then
    sh 1200-debian-hyprland*
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
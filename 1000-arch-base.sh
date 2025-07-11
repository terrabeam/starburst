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
tput setaf 3
echo "################################################################"
echo "################### Start Arch setup"
echo "################################################################"
tput sgr0
echo

# Setting installed_dir to base folder of the git-repository
installed_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Installing chaotic-aur keys and mirrors
pkg_dir="packages"

# Ensure directory exists
if [[ ! -d "$pkg_dir" ]]; then
    echo "Directory not found: $pkg_dir"
    exit 1
fi

# Install all local packages using pacman
find "$pkg_dir" -maxdepth 1 -name '*.pkg.tar.zst' -print0 | sudo xargs -0 pacman -U --noconfirm


# personal pacman.conf
if [[ ! -f /etc/pacman.conf.starburst ]]; then
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Copying /etc/pacman.conf to /etc/pacman.conf.starburst"
    echo "################################################################################"
    tput sgr0
    echo
    sudo cp -v /etc/pacman.conf /etc/pacman.conf.starburst
    echo
else
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Backup already exists: /etc/pacman.conf.starburst"
    echo "################################################################################"
    tput sgr0
    echo
fi

sudo cp -v $installed_dir/config-files/pacman.conf /etc/pacman.conf

echo
tput setaf 2
echo "################################################################################"
echo "Updating the system - sudo pacman -Syyu"
echo "################################################################################"
tput sgr0
echo

sudo pacman -Syyu --noconfirm

sh 1010-select-desktop.sh
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
echo "################### Start current choices"
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
#find "$pkg_dir" -maxdepth 1 -name '*.pkg.tar.zst' -print0 | sudo xargs -0 pacman -U --noconfirm


echo
tput setaf 2
echo "################################################################################"
echo "Updating the system - sudo apt update"
echo "################################################################################"
tput sgr0
echo

sudo apt update && sudo apt full-upgrade -y

echo
tput setaf 2
echo "################################################################################"
echo "Installing much needed software"
echo "################################################################################"
tput sgr0
echo

#first get tools for whatever distro
#sudo apt install -y sublime-text-4
sudo apt install -y ripgrep
sudo apt install -y meld
sudo apt install -y wget
sudo apt install -y curl
sudo apt install -y nano
sudo apt install -y fastfetch
#sudo apt install -y lolcat
#sudo apt install -y terminus-font
sudo apt install -y bash-completion

tput setaf 3
echo "################################################################"
echo "End current choices"
echo "################################################################"
tput sgr0

sh 1010-select-desktop.sh
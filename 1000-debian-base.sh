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
echo "################### Start Debian setup"
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

echo
tput setaf 2
echo "################################################################################"
echo "Updating the system - sudo apt update"
echo "################################################################################"
tput sgr0
echo

sudo apt update && sudo apt full-upgrade -y

tput setaf 3
echo "################################################################"
echo "End current choices"
echo "################################################################"
tput sgr0

sh 1010-select-desktop.sh
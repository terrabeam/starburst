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
echo "################### Start OS Detection"
echo "################################################################"
tput sgr0
echo

# Detect OS and set flags
OS=""
if grep -qi "arch" /etc/os-release; then
    OS="arch"
elif grep -qi "debian" /etc/os-release; then
    OS="debian"
fi

# If unknown, exit
if [[ -z "$OS" ]]; then
    tput setaf 1
    echo "################################################################################"
    echo "ERROR: Unsupported or unknown Linux distribution."
    echo "This script only supports Arch-based or Debian-based systems."
    echo "################################################################################"
    tput sgr0
    exit 1
fi

# Show detected OS
tput setaf 6
echo "################################################################################"
echo "Detected OS: ${OS:-unknown}"
echo "################################################################################"
tput sgr0

if [[ "$OS" == "arch" ]]; then
    echo "Running Arch Linux setup steps..."
    # your pacman install section goes here
    sh 100-arch-base.sh
fi

if [[ "$OS" == "debian" ]]; then
    echo "Running Debian setup steps..."
    # your apt install section goes here
    sh 100-debian-base.sh
fi

if [[ -z "$OS" ]]; then
    tput setaf 3
    echo "Warning: Unknown Linux distribution. Script may not work as expected."
    tput sgr0
fi

tput setaf 3
echo "################################################################"
echo "End OS Detection"
echo "################################################################"
tput sgr0
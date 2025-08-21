#!/bin/bash
set -euo pipefail

#################################################################
# Colors
# tput setaf 0 = black, 1 = red, 2 = green, 3 = yellow
# tput setaf 4 = blue, 5 = purple, 6 = cyan, 7 = gray
#################################################################

. /etc/os-release
DISTRO=$ID

installed_dir="$(dirname "$(readlink -f "$0")")"

#################################################################
# Debug mode
#################################################################
if [ "${DEBUG:-false}" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename "$0")"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

#################################################################
# Functions for package management
#################################################################
install_pkgs() {
    case "$DISTRO" in
        arch)
            sudo pacman -S --noconfirm --needed "$@"
            ;;
        debian|ubuntu)
            sudo apt-get update
            sudo apt-get install -y "$@"
            ;;
    esac
}

remove_pkgs() {
    case "$DISTRO" in
        arch)
            sudo pacman -Rs --noconfirm "$@"
            ;;
        debian|ubuntu)
            sudo apt-get remove -y "$@"
            ;;
    esac
}

#################################################################
# Install XFCE and SDDM
#################################################################
echo
tput setaf 2
echo "########################################################################"
echo "################### Install XFCE4 Minimal"
echo "########################################################################"
tput sgr0
echo

if [ "$DISTRO" = "arch" ]; then
    install_pkgs xfce4 xfce4-goodies sddm
    remove_pkgs mousepad parole xfburn xfce4-screenshooter xfce4-notes-plugin
else
    install_pkgs xfce4 xfce4-goodies sddm
    remove_pkgs mousepad parole xfburn xfce4-screenshooter xfce4-notes
fi

#################################################################
# Create directories (skel + user)
#################################################################
echo
tput setaf 2
echo "########################################################################"
echo "################### Creating directories"
echo "########################################################################"
tput sgr0
echo

sudo mkdir -p /etc/skel/.config/xfce4/{panel,xfconf}
mkdir -p \
    "$HOME"/{.bin,.fonts,.icons,.themes,DATA} \
    "$HOME/.local/share/"{icons,themes,applications} \
    "$HOME/.config/"{xfce4,autostart,xfce4/xfconf,gtk-{3.0,4.0},variety,fish,neofetch}

#################################################################
# Enable SDDM
#################################################################
echo
tput setaf 6
echo "##############################################################"
echo "################### Enabling SDDM"
echo "##############################################################"
tput sgr0
echo

sudo systemctl disable lightdm.service 2>/dev/null || true
sudo systemctl enable sddm.service

#################################################################
# Done
#################################################################
echo
tput setaf 6
echo "##############################################################"
echo "################### $(basename "$0") done"
echo "##############################################################"
tput sgr0
echo

#!/bin/bash
set -euo pipefail

##########################
# Color helpers
##########################
tput_reset() { tput sgr0; }
tput_black() { tput setaf 0; }
tput_red() { tput setaf 1; }
tput_green() { tput setaf 2; }
tput_yellow() { tput setaf 3; }
tput_blue() { tput setaf 4; }
tput_purple() { tput setaf 5; }
tput_cyan() { tput setaf 6; }
tput_gray() { tput setaf 7; }

echo
tput_yellow
echo "################################################################################"
echo "################### Detected OS / Desktop Environmet / Tiling Window Manager"
echo "################################################################################"
tput_reset
echo

echo "Installing OS-specific packages..."
echo "Selected DE: $SELECTED_DE"
echo "Selected TWM: $SELECTED_TWM"
echo "Installation Level: $INSTALL_LEVEL"

if [[ "$SELECTED_DE" == "xfce" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing XFCE4"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing XFCE packages..."

fi

if [[ "$SELECTED_DE" == "plasma" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing KDE Plasma 6"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing Plasma packages..."
fi

if [[ "$SELECTED_DE" == "gnome" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing Gnome 48"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing Gnome packages..."
fi

if [[ "$SELECTED_DE" == "none" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing no Desktop Environment"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing no Desktop Environment packages..."
fi


if [[ "$SELECTED_TWM" == "chadwm" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing Chadwm"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing CHADWM..."
fi

if [[ "$SELECTED_TWM" == "hyprland" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing Hyprland"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing Hyperland..."
fi

if [[ "$SELECTED_TWM" == "none" ]]; then
    echo
    tput_green
    echo "################################################################################"
    echo "################### Installing no Tiling Window Manager"
    echo "################################################################################"
    tput_reset
    echo

    echo "Installing no Tiling Window Manager packages..."
fi

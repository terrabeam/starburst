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
echo "####################################################################################"
echo "################### Detected OS / Desktop Environmet / Tiling Window Manager"
echo "####################################################################################"
tput_reset
echo

echo "Installing OS-specific packages..."
echo "Selected DE: $SELECTED_DE"
echo "Selected TWM: $SELECTED_TWM"

if [[ "$SELECTED_DE" == "xfce" ]]; then
    echo "Installing XFCE packages..."
fi

if [[ "$SELECTED_DE" == "plasma" ]]; then
    echo "Installing Plasma packages..."
fi

if [[ "$SELECTED_DE" == "gnome" ]]; then
    echo "Installing Gnome packages..."
fi

if [[ "$SELECTED_DE" == "none" ]]; then
    echo "Installing no Desktop Environment packages..."
fi


if [[ "$SELECTED_TWM" == "chadwm" ]]; then
    echo "Installing CHADWM..."
fi

if [[ "$SELECTED_TWM" == "chadwm" ]]; then
    echo "Installing CHADWM..."
fi

if [[ "$SELECTED_TWM" == "none" ]]; then
    echo "Installing no Tiling Window Manager packages..."
fi

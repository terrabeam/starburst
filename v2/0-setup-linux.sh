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
echo "################################################################"
echo "################### Start OS Detection"
echo "################################################################"
tput_reset
echo

##########################
# OS Detection
##########################
source /etc/os-release

OS_ID=${ID,,}
OS_LIKE=${ID_LIKE,,}
OS_VERSION="$VERSION_ID"
OS_PRETTY="$PRETTY_NAME"
OS=""

case "$OS_ID" in
    arch)   OS="arch" ;;
    debian) OS="debian" ;;
    ubuntu) OS="ubuntu" ;;
    fedora) OS="fedora" ;;
    *)
        # fallback detection using ID_LIKE for derivatives
        if [[ "$OS_LIKE" == *"ubuntu"* ]]; then
            OS="ubuntu"
        elif [[ "$OS_LIKE" == *"arch"* ]]; then
            OS="arch"
        elif [[ "$OS_LIKE" == *"debian"* ]]; then
            OS="debian"
        elif [[ "$OS_LIKE" == *"fedora"* || "$OS_LIKE" == *"rhel"* ]]; then
            OS="fedora"
        fi
        ;;
esac

if [[ -n "$OS" ]]; then
    tput_cyan
    echo "################################################################################"
    echo "Detected OS: $OS ($OS_PRETTY)"
    echo "Version: $OS_VERSION"
    echo "################################################################################"
    tput_reset
else
    tput_red
    echo "################################################################################"
    echo "ERROR: Unsupported or unknown Linux distribution."
    echo "Detected: ID=$OS_ID, ID_LIKE=$OS_LIKE"
    echo "################################################################################"
    tput_reset
    exit 1
fi

##########################
# Desktop Environment Detection / Selection
##########################
echo
tput_yellow
echo "################################################################"
echo "################### Desktop Environment Selection"
echo "################################################################"
tput_reset
echo

DE_RAW="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}"
DE=""

case "${DE_RAW,,}" in
    *xfce*)          DE="xfce" ;;
    *plasma*|*kde*)  DE="plasma" ;;
    *gnome*)         DE="gnome" ;;
    ""|none)         DE="" ;;  # trigger menu
esac

if [[ -n "$DE" ]]; then
    tput_cyan
    echo "################################################################################"
    echo "Detected Desktop Environment: $DE (${DE_RAW})"
    echo "################################################################################"
    tput_reset
else
    # No DE detected — ask user
    echo "No Desktop Environment detected. Select one to install:"
    while true; do
        echo "  1) XFCE"
        echo "  2) Plasma"
        echo "  3) GNOME"
        echo "  x) None (default)"
        read -rp "Enter choice [1/2/3/x] (default: x): " choice
        case "${choice,,}" in
            1) DE="xfce"; break ;;
            2) DE="plasma"; break ;;
            3) DE="gnome"; break ;;
            x|"") DE="none"; break ;;
            *) echo "Invalid option. Please enter 1, 2, 3, or x." ;;
        esac
    done
    tput_cyan
    echo "################################################################################"
    echo "Selected Desktop Environment: $DE"
    echo "################################################################################"
    tput_reset
fi

##########################
# Tiling Window Manager Selection
##########################
echo
tput_yellow
echo "################################################################"
echo "################### Tiling WM Selection"
echo "################################################################"
tput_reset
echo

TWM="none"
while true; do
    echo "Select a tiling window manager:"
    echo "  1) CHADWM"
    echo "  2) Hyprland"
    echo "  x) None (default)"
    read -rp "Enter choice [1/2/x] (default: x): " choice
    case "${choice,,}" in
        1) TWM="chadwm"; break ;;
        2) TWM="hyprland"; break ;;
        x|"") TWM="none"; break ;;
        *) echo "Invalid option. Please enter 1, 2, or x." ;;
    esac
done

tput_cyan
echo "################################################################################"
echo "Selected Tiling WM: $TWM"
echo "################################################################################"
tput_reset

##########################
# Preflight check for setup script
##########################
SCRIPT="./${OS}-${DE}-${TWM}.sh"

if [[ ! -x "$SCRIPT" ]]; then
    tput_red
    echo "################################################################################"
    echo "ERROR: Setup script not found: $SCRIPT"
    echo "Please create the appropriate script for your configuration."
    echo "Expected script naming: os-de-twm.sh"
    echo
    echo "Examples you might need:"
    echo "  arch-xfce-none.sh"
    echo "  ubuntu-gnome-hyprland.sh"
    echo "  debian-none-none.sh"
    echo "  fedora-plasma-chadwm.sh"
    echo "################################################################################"
    tput_reset
    exit 1
fi

##########################
# Headless detection
##########################
if [[ "$DE" == "none" && "$TWM" == "none" ]]; then
    echo "Detected headless system. Running headless setup..."
fi

##########################
# Run setup script
##########################
echo "Running setup: $SCRIPT"
"$SCRIPT"

tput_yellow
echo "################################################################"
echo "End Detection"
echo "################################################################"
tput_reset

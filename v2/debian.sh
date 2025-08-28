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

##########################
# Use exported variables from main detection script
##########################
DE="${SELECTED_DE:-none}"
TWM="${SELECTED_TWM:-none}"
INSTALL_LEVEL="${INSTALL_LEVEL:-minimal}"

tput_cyan
echo "Starting Debian setup..."
tput_reset
echo "DE: $DE, TWM: $TWM, Install Level: $INSTALL_LEVEL"

##########################
# 0. Ensure curl is installed
##########################
if ! command -v curl >/dev/null 2>&1; then
    tput_yellow
    echo "curl is not installed. Installing..."
    tput_reset
    sudo apt update
    sudo apt -y install curl
fi

##########################
# 1. Add contrib and non-free if missing
##########################
tput_yellow
echo "Checking /etc/apt/sources.list for contrib/non-free..."
tput_reset
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s)
sudo sed -i -r 's/^(deb\s+\S+\s+\S+)\s+(main)$/\1 main contrib non-free/' /etc/apt/sources.list
tput_green
echo "Updated sources.list to include contrib/non-free where needed."
tput_reset

##########################
# 2. Full update and upgrade
##########################
tput_yellow
echo "Updating package lists..."
tput_reset
sudo apt update

tput_yellow
echo "Upgrading installed packages..."
tput_reset
sudo apt -y full-upgrade

UPGRADE_PENDING=$(apt list --upgradable 2>/dev/null | grep -v Listing || true)

if [[ -n "$UPGRADE_PENDING" ]]; then
    tput_red
    echo
    echo "Some packages were upgraded. A reboot is recommended before continuing."
    tput_reset
    read -rp "Reboot now? [y/N]: " reboot_choice
    case "${reboot_choice,,}" in
        y|yes)
            tput_red
            echo "Rebooting now. After reboot, please restart this script to continue..."
            tput_reset
            sudo reboot
            ;;
        *)
            tput_yellow
            echo "Skipping reboot. Make sure to reboot manually before continuing upgrades."
            tput_reset
            exit 0
            ;;
    esac
else
    tput_green
    echo "All packages are up to date. Continuing to Debian major version check..."
    tput_reset
fi

##########################
# 3. Stepwise major version upgrade
##########################
DEBIAN_SEQUENCE=(buster bullseye bookworm trixie)
CURRENT_CODENAME=$(grep -Po 'deb\s+\S+\s+\K\S+' /etc/apt/sources.list | grep -E '^(buster|bullseye|bookworm|trixie)$' | head -n1)
LATEST_CODENAME=${DEBIAN_SEQUENCE[-1]}

tput_cyan
echo "Current codename: $CURRENT_CODENAME"
echo "Latest stable codename: $LATEST_CODENAME"
tput_reset

while [[ "$CURRENT_CODENAME" != "$LATEST_CODENAME" ]]; do
    NEXT_CODENAME=""
    for i in "${!DEBIAN_SEQUENCE[@]}"; do
        if [[ "${DEBIAN_SEQUENCE[$i]}" == "$CURRENT_CODENAME" ]]; then
            NEXT_CODENAME="${DEBIAN_SEQUENCE[$((i+1))]}"
            break
        fi
    done

    if [[ -z "$NEXT_CODENAME" ]]; then
        tput_red
        echo "Error: Cannot determine next codename after $CURRENT_CODENAME"
        tput_reset
        exit 1
    fi

    tput_yellow
    echo
    echo "Detected codename $CURRENT_CODENAME, next stable version: $NEXT_CODENAME"
    tput_reset
    read -rp "Do you want to upgrade to $NEXT_CODENAME? [y/N]: " choice
    case "${choice,,}" in
        y|yes)
            tput_yellow
            echo "Updating sources.list to $NEXT_CODENAME..."
            tput_reset
            sudo sed -i -r "s/\b$CURRENT_CODENAME\b/$NEXT_CODENAME/g" /etc/apt/sources.list

            tput_yellow
            echo "Updating packages..."
            tput_reset
            sudo apt update
            sudo apt -y full-upgrade

            tput_green
            echo "Upgrade to $NEXT_CODENAME complete. Reboot recommended."
            tput_reset
            read -rp "Please reboot and restart this script to continue. Press Enter to exit..." _
            exit 0
            ;;
        *)
            tput_yellow
            echo "Skipping upgrade to $NEXT_CODENAME. Continuing with current version."
            tput_reset
            break
            ;;
    esac

    CURRENT_CODENAME=$(grep -Po 'deb\s+\S+\s+\K\S+' /etc/apt/sources.list | grep -E '^(buster|bullseye|bookworm|trixie)$' | head -n1)
done

tput_green
echo "Debian is now at codename $CURRENT_CODENAME. Continuing with DE/TWM installation..."
tput_reset

##########################
# 4. Desktop Environment installation
##########################
case "$DE" in
    xfce)
        tput_yellow
        echo "Installing XFCE..."
        tput_reset
        sudo apt -y install task-xfce-desktop
        ;;
    plasma)
        tput_yellow
        echo "Installing KDE Plasma..."
        tput_reset
        sudo apt -y install task-kde-desktop
        ;;
    gnome)
        tput_yellow
        echo "Installing GNOME..."
        tput_reset
        sudo apt -y install task-gnome-desktop
        ;;
    none)
        tput_gray
        echo "No desktop environment selected."
        tput_reset
        ;;
esac

##########################
# 5. Tiling Window Manager installation
##########################
case "$TWM" in
    chadwm)
        tput_yellow
        echo "Installing CHADWM..."
        tput_reset
        # add CHADWM install commands here
        ;;
    hyprland)
        tput_yellow
        echo "Installing Hyprland..."
        tput_reset
        # add Hyprland install commands here
        ;;
    none)
        tput_gray
        echo "No tiling window manager selected."
        tput_reset
        ;;
esac

##########################
# 6. Installation level handling
##########################
case "$INSTALL_LEVEL" in
    minimal)
        tput_blue
        echo "Minimal installation selected."
        tput_reset
        ;;
    full)
        tput_blue
        echo "Full installation selected."
        tput_reset
        ;;
    workstation)
        tput_blue
        echo "Workstation installation selected."
        tput_reset
        ;;
    server)
        tput_blue
        echo "Server installation selected."
        tput_reset
        ;;
esac

tput_green
echo "Debian setup complete."
tput_reset

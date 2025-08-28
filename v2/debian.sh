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

echo "Starting Debian setup..."
echo "DE: $DE, TWM: $TWM, Install Level: $INSTALL_LEVEL"

##########################
# 0. Ensure curl is installed
##########################
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed. Installing..."
    sudo apt update
    sudo apt -y install curl
fi

##########################
# 1. Add contrib and non-free if missing
##########################
echo "Checking /etc/apt/sources.list for contrib/non-free..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s)
sudo sed -i -r 's/^(deb\s+\S+\s+\S+)\s+(main)$/\1 main contrib non-free/' /etc/apt/sources.list
echo "Updated sources.list to include contrib/non-free where needed."

##########################
# 2. Full update and upgrade
##########################
echo "Updating package lists..."
sudo apt update
echo "Upgrading installed packages..."
sudo apt -y full-upgrade

UPGRADE_PENDING=$(apt list --upgradable 2>/dev/null | grep -v Listing || true)

if [[ -n "$UPGRADE_PENDING" ]]; then
    echo
    echo "Some packages were upgraded. A reboot is recommended before continuing."
    read -rp "Reboot now? [y/N]: " reboot_choice
    case "${reboot_choice,,}" in
        y|yes)
            echo "Rebooting now. After reboot, please restart this script to continue..."
            sudo reboot
            ;;
        *)
            echo "Skipping reboot. Make sure to reboot manually before continuing upgrades."
            exit 0
            ;;
    esac
else
    echo "All packages are up to date. Continuing to Debian major version check..."
fi

##########################
# 3. Multi-stage major version upgrade (robust)
##########################
CURRENT_DEBIAN_VERSION=$(cut -d. -f1 /etc/debian_version)

# Reliable codename → version mapping
declare -A DEBIAN_VERSIONS=(
    [buster]=10
    [bullseye]=11
    [bookworm]=12
    [trixie]=13
    [forky]=14   # future release
    [duke]=15   # future release
)

# Determine latest stable release
LATEST_CODENAME=$(printf "%s\n" "${!DEBIAN_VERSIONS[@]}" | sort -V | tail -n1)
LATEST_VERSION=${DEBIAN_VERSIONS[$LATEST_CODENAME]}

echo "Latest Debian stable: $LATEST_CODENAME ($LATEST_VERSION)"

# Only run upgrade loop if needed
if [[ $CURRENT_DEBIAN_VERSION -lt $LATEST_VERSION ]]; then
    while [[ $CURRENT_DEBIAN_VERSION -lt $LATEST_VERSION ]]; do
        NEXT_VERSION=$((CURRENT_DEBIAN_VERSION+1))
        echo
        echo "Detected Debian $CURRENT_DEBIAN_VERSION, next major version available: $NEXT_VERSION ($LATEST_CODENAME)."
        read -rp "Do you want to upgrade to Debian $NEXT_VERSION? [y/N]: " choice
        case "${choice,,}" in
            y|yes)
                echo "Preparing to upgrade from Debian $CURRENT_DEBIAN_VERSION to $NEXT_VERSION..."
                # Update sources.list for new release
                sudo sed -i -r "s/debian[0-9]*/$LATEST_CODENAME/g" /etc/apt/sources.list
                sudo apt update
                sudo apt -y full-upgrade
                echo
                echo "Upgrade to Debian $NEXT_VERSION complete. A reboot is recommended before continuing."
                read -rp "Please reboot your system and restart this script to continue. Press Enter to exit..." _
                exit 0
                ;;
            *)
                echo "Skipping upgrade to $NEXT_VERSION. Continuing with current version."
                break
                ;;
        esac
        CURRENT_DEBIAN_VERSION=$(cut -d. -f1 /etc/debian_version)
    done
fi

echo "Debian is now at version $CURRENT_DEBIAN_VERSION."

##########################
# 4. Desktop Environment installation
##########################
echo "Continuing with Desktop Environment and Tiling WM installation..."

case "$DE" in
    xfce)
        echo "Installing XFCE..."
        sudo apt -y install task-xfce-desktop
        ;;
    plasma)
        echo "Installing KDE Plasma..."
        sudo apt -y install task-kde-desktop
        ;;
    gnome)
        echo "Installing GNOME..."
        sudo apt -y install task-gnome-desktop
        ;;
    none)
        echo "No desktop environment selected."
        ;;
esac

##########################
# 5. Tiling Window Manager installation
##########################
case "$TWM" in
    chadwm)
        echo "Installing CHADWM..."
        # add CHADWM install commands here with sudo if needed
        ;;
    hyprland)
        echo "Installing Hyprland..."
        # add Hyprland install commands here with sudo if needed
        ;;
    none)
        echo "No tiling window manager selected."
        ;;
esac

##########################
# 6. Installation level handling
##########################
case "$INSTALL_LEVEL" in
    minimal)
        echo "Minimal installation selected."
        ;;
    full)
        echo "Full installation selected."
        ;;
    workstation)
        echo "Workstation installation selected."
        ;;
    server)
        echo "Server installation selected."
        ;;
esac

echo "Debian setup complete."

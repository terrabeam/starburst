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
# Resume marker check
##########################
if [[ -f /root/.debian_upgrade_continue ]]; then
    echo "Resuming post-reboot Debian setup..."
    rm -f /root/.debian_upgrade_continue
fi

##########################
# Use exported variables from main detection script
##########################
DE="${SELECTED_DE:-none}"
TWM="${SELECTED_TWM:-none}"
INSTALL_LEVEL="${INSTALL_LEVEL:-minimal}"

echo "Starting Debian setup..."
echo "DE: $DE, TWM: $TWM, Install Level: $INSTALL_LEVEL"

##########################
# 1. Add contrib and non-free if missing
##########################
echo "Checking /etc/apt/sources.list for contrib/non-free..."

# Backup sources.list first
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%s)

# Add contrib and non-free if missing
sudo sed -i -r 's/^(deb\s+\S+\s+\S+)\s+(main)$/\1 main contrib non-free/' /etc/apt/sources.list

echo "Updated sources.list to include contrib/non-free where needed."

##########################
# 2. Full update and upgrade
##########################
echo "Updating package lists..."
sudo apt update

echo "Upgrading installed packages..."
sudo apt -y full-upgrade

echo "System updated. Rebooting now to continue..."
sudo touch /root/.debian_upgrade_continue
sudo reboot

##########################
# 3. Multi-stage major version upgrade
##########################
# This section runs after reboot

CURRENT_DEBIAN_VERSION=$(cut -d. -f1 /etc/debian_version)
LATEST_DEBIAN_VERSION=13  # adjust to latest stable when needed

while [[ $CURRENT_DEBIAN_VERSION -lt $LATEST_DEBIAN_VERSION ]]; do
    NEXT_VERSION=$((CURRENT_DEBIAN_VERSION+1))
    echo "Detected Debian $CURRENT_DEBIAN_VERSION, next stable is $NEXT_VERSION."
    read -rp "Do you want to upgrade to Debian $NEXT_VERSION? [y/N]: " choice
    case "${choice,,}" in
        y|yes)
            echo "Preparing to upgrade from Debian $CURRENT_DEBIAN_VERSION to $NEXT_VERSION..."

            # Optional: convert version number to codename
            case $NEXT_VERSION in
                11) CODENAME="bullseye" ;;
                12) CODENAME="bookworm" ;;
                13) CODENAME="trixie" ;; # replace with current stable codename if different
                *) CODENAME="" ;;
            esac

            if [[ -n "$CODENAME" ]]; then
                sudo sed -i -r "s/debian[0-9]*/$CODENAME/g" /etc/apt/sources.list
            else
                # fallback: replace major version number
                sudo sed -i -r "s/debian[0-9]*/debian$NEXT_VERSION/g" /etc/apt/sources.list
            fi

            # Update and full-upgrade
            sudo apt update
            sudo apt -y full-upgrade

            echo "Upgrade to Debian $NEXT_VERSION complete. Rebooting..."
            sudo touch /root/.debian_upgrade_continue
            sudo reboot
            ;;
        *)
            echo "Skipping upgrade to $NEXT_VERSION. Continuing with current version."
            break
            ;;
    esac

    # After reboot, detect version again
    CURRENT_DEBIAN_VERSION=$(cut -d. -f1 /etc/debian_version)
    echo "Current Debian version after reboot: $CURRENT_DEBIAN_VERSION"
done

echo "Debian is now at version $CURRENT_DEBIAN_VERSION."

##########################
# 4. Continue with DE/TWM/install level setup
##########################
echo "Continuing with Desktop Environment and Tiling WM installation..."

# Example: install selected DE
case "$DE" in
    xfce)
        echo "Installing XFCE..."
        #apt -y install task-xfce-desktop
        ;;
    plasma)
        echo "Installing KDE Plasma..."
        #apt -y install task-kde-desktop
        ;;
    gnome)
        echo "Installing GNOME..."
        #apt -y install task-gnome-desktop
        ;;
    none)
        #echo "No desktop environment selected."
        ;;
esac

# Example: install Tiling WM
case "$TWM" in
    chadwm)
        echo "Installing CHADWM..."
        # add your CHADWM install commands here
        ;;
    hyprland)
        echo "Installing Hyprland..."
        # add your Hyprland install commands here
        ;;
    none)
        echo "No tiling window manager selected."
        ;;
esac

# Example: handle install level
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

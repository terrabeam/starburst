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
OS="${DETECTED_OS}"
DDE="${DETECTED_DE}"
DE="${SELECTED_DE:-none}"
TWM="${SELECTED_TWM:-none}"
INSTALL_LEVEL="${INSTALL_LEVEL:-minimal}"

##########################
# 4. Desktop Environment installation
##########################
tput_yellow
echo "Installing XFCE..."
tput_reset

#detect if XFCE and SDDM are installed and if not install them
if [[ -z "$DDE" ]]; then
    tput_cyan
    echo
    echo "No Desktop Environment detected. Installing XFCE (light setup with SDDM)..."
    tput_reset

    sudo apt update
    sudo apt install -y --no-install-recommends plasma-desktop dolphin konsole kate plasma-nm kde-config-systemd kde-spectacle sddm

    # Enable SDDM as the display manager
    sudo systemctl enable sddm

    # Enable graphical target
    sudo systemctl set-default graphical.target

    tput_green
    echo
    echo "XFCE with SDDM installed successfully."
    echo "You can reboot now to start XFCE."
    tput_reset
else
    tput_cyan
    echo
    echo "You already have $DE installed."
    tput_reset

    # Check if LightDM is installed and active
    if systemctl is-active --quiet lightdm; then
        tput_yellow
        echo
        echo "LightDM is currently active. Replacing with SDDM..."
        tput_reset

        # Disable and remove LightDM
        sudo systemctl disable lightdm
        sudo apt purge -y lightdm lightdm-gtk-greeter

        # Install and enable SDDM
        sudo apt install -y sddm
        sudo systemctl enable sddm

        # Enable graphical target
        sudo systemctl set-default graphical.target

        tput_green
        echo
        echo "LightDM removed and replaced with SDDM."
        tput_reset
    else
        tput_cyan
        echo
        echo "No LightDM detected, leaving current display manager unchanged."
        tput_reset
    fi
fi

#cleanup unwanted packages
    # Packages to remove
    packages=("vim" "vim-runtime" "vim-common" "vim-tiny" "mousepad" "parole" "xfburn" "xfce4-screenshooter" "xfce4-notes")  
    sudo apt-mark manual xfce4-goodies
    
    # Function to check if a package is installed
    is_package_installed() {
        dpkg -s "$1" &> /dev/null
    }

    # Iterate over each package
    for package in "${packages[@]}"; do
        if is_package_installed "$package"; then
            echo "Removing $package..."
            sudo apt-get purge -y "$package"
        else
            echo "$package is not installed, skipping."
        fi

        # Optional double-check
        if ! is_package_installed "$package"; then
            echo "$package successfully removed."
        else
            echo "$package is still installed. Check manually."
        fi

        echo "----------------------------"
    done

    # Remove leftover dependencies
    sudo apt-get autoremove -y


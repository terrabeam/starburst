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
DE="${SELECTED_DE:-none}"
TWM="${SELECTED_TWM:-none}"
INSTALL_LEVEL="${INSTALL_LEVEL:-minimal}"

##########################
# 4. Desktop Environment installation
##########################
case "$DE" in
    xfce)
        tput_yellow
        echo "Installing XFCE..."
        tput_reset
        
        #sudo apt -y install task-xfce-desktop
        if [[ "$CURRENT_DE" == "NONE" ]]; then
            tput_cyan
            echo "No Desktop Environment detected. Installing XFCE (light setup with SDDM)..."
            tput_reset

            sudo apt update
            sudo apt install -y xfce4 xfce4-goodies sddm

            # Enable SDDM as the display manager
            sudo systemctl enable sddm

            tput_green
            echo "XFCE with SDDM installed successfully."
            echo "You can reboot now to start XFCE."
            tput_reset
        else
            tput_cyan
            echo "You already have $CURRENT_DE installed."
            tput_reset

            # Check if LightDM is installed and active
            if systemctl is-active --quiet lightdm; then
                tput_yellow
                echo "LightDM is currently active. Replacing with SDDM..."
                tput_reset

                # Disable and remove LightDM
                sudo systemctl disable lightdm
                sudo apt purge -y lightdm lightdm-gtk-greeter

                # Install and enable SDDM
                sudo apt install -y sddm
                sudo systemctl enable sddm

                tput_green
                echo "LightDM removed and replaced with SDDM."
                tput_reset
            else
                tput_cyan
                echo "No LightDM detected, leaving current display manager unchanged."
                tput_reset
            fi
        fi
        ;;
    plasma)
        tput_yellow
        echo "Installing KDE Plasma..."
        tput_reset
        #sudo apt -y install task-kde-desktop
        ;;
    gnome)
        tput_yellow
        echo "Installing GNOME..."
        tput_reset
        #sudo apt -y install task-gnome-desktop
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

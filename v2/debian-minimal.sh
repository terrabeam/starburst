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
tput_cyan() { tput setaf 4; }
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

# Pause
read -n 1 -s -r -p "Press any key to continue"

# on all DE
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
        "$HOME/.config/"{autostart,gtk-{3.0,4.0},variety,fish,neofetch}

    # Packages to remove
    packages=("vim" "vim-runtime" "vim-common" "vim-tiny" "mousepad" "parole")  
    
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

    # install needed packages
        #firmwares
        sudo apt-get install -y \
        dkms \
        linux-headers-$(uname -r)

        #archive-managers
        sudo apt install -y zip gzip p7zip unace unrar unzip
        
        #fonts
        sudo apt install -y \
        font-manager \
        fonts-noto \
        fonts-dejavu \
        fonts-droid-fallback \
        fonts-hack \
        fonts-inconsolata \
        fonts-liberation \
        fonts-roboto \
        fonts-ubuntu \
        fonts-terminus

        # Install RobotoMono Nerd Font
            # Destination directory
            FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"

            # Download RobotoMono Nerd Font (latest release)
            ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip"
            TMP_DIR="$(mktemp -d)"

            echo "Downloading RobotoMono Nerd Font..."
            curl -L "$ZIP_URL" -o "$TMP_DIR/RobotoMono.zip"

            echo "Extracting..."
            unzip -q "$TMP_DIR/RobotoMono.zip" -d "$FONT_DIR"

            echo "Cleaning up..."
            rm -rf "$TMP_DIR"

            echo "Updating font cache..."
            fc-cache -fv

            echo "RobotoMono Nerd Font installed successfully in $FONT_DIR"

        #tools
        sudo apt install -y \
        wget \
        curl \
        nano \
        fastfetch \
        lolcat \
        bash-completion \
        starship \
        alacritty \
        hwinfo \
        lshw \
        libpam0g \
        libpam-modules \
        libpam-runtime \
        libpam-modules-bin \
        avahi-daemon \
        avahi-utils \
        libnss-mdns

        if [ ! -f /usr/bin/duf ]; then
        sudo apt install -y duf
        fi
        sudo apt install -y \
        man-db \
        manpages \
        tree \
        xdg-user-dirs \
        mate-polkit \
        rsync \
        time \
        bat \
        chrony

        #theming
        sudo apt install -y \
        bibata-cursor-theme \
        feh \
        arc-theme

        echo "Installing Surfn icon theme..."
        # Clone Surfn repo
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/erikdubois/Surfn.git "$TEMP_DIR/surfn"
        cd "$TEMP_DIR/surfn"
        # Copy the icon theme to the user's local icons directory
        cp -r surfn-icons ~/.icons/
        cd ~
        rm -rf "$TEMP_DIR"
        echo "Surfn icon theme installed."

        echo "Installing Flat Remix Dark GTK theme..."
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        # Download latest master as tar.gz
        wget -O flat-remix-gtk.tar.gz https://github.com/daniruiz/flat-remix-gtk/archive/refs/heads/master.tar.gz
        # Extract
        tar -xzf flat-remix-gtk.tar.gz
        # Move the Dark GTK theme to ~/.themes
        # The actual theme folder is "Flat-Remix-Dark" inside the extracted directory
        mv flat-remix-gtk-master/themes/Flat-Remix-Dark ~/.themes/
        cd ~
        rm -rf "$TEMP_DIR"
        echo "Flat Remix Dark GTK theme installed."

        #internet
        sudo apt install -y \
        chromium

        #enable services
        sudo systemctl enable avahi-daemon.service
        sudo systemctl enable chrony

        #Run service that will discard unused blocks on mounted filesystems. This is useful for solid-state drives (SSDs) and thinly-provisioned storage. 
        echo
        echo "Enable fstrim timer"
        sudo systemctl enable fstrim.timer

        echo
        tput setaf 3
        echo "########################################################################"
        echo "Detecting virtualization platform..."
        echo "########################################################################"
        tput sgr0
        echo

        virt_type=$(systemd-detect-virt)

        case "$virt_type" in
            kvm)
                echo "Detected KVM. Installing qemu-guest-agent..."
                sudo apt install -y qemu-guest-agent spice-vdagent
                sudo systemctl enable qemu-guest-agent.service
                ;;
            oracle)
                echo "Detected VirtualBox. Installing virtualbox-guest-utils..."
                sudo apt install -y virtualbox-guest-utils
                sudo systemctl enable vboxservice.service
                ;;
            none)
                echo "No virtualization detected. Skipping guest utilities."
                ;;
            *)
                echo "Virtualization detected: $virt_type, but no install routine defined."
                ;;
        esac

# if on XFCE
case "$DE" in
    xfce)
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
            "$HOME/.config/"{xfce4,xfce4/xfconf}
        
        # cleanup unwanted packages
        tput_yellow
        echo
        echo "Removing unwanted packages from $DE..."
        tput_reset

        # Packages to remove
        packages=("xfburn" "xfce4-screenshooter" "xfce4-notes")  
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

        # install needed packages
            #tools
            sudo apt install -y thunar thunar-archive-plugin thunar-volman

            #archive-managers
            sudo apt install -y file-roller


        ;;
esac






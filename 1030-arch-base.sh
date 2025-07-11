#!/bin/bash
#set -e
##################################################################################################################
#tput setaf 0 = black 
#tput setaf 1 = red 
#tput setaf 2 = green
#tput setaf 3 = yellow 
#tput setaf 4 = dark blue 
#tput setaf 5 = purple
#tput setaf 6 = cyan 
#tput setaf 7 = gray 
#tput setaf 8 = light blue
##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Start Arch setup"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################################"
echo "Installing much needed software"
echo "################################################################################"
tput sgr0
echo

#first get tools for whatever distro
sudo pacman -S --noconfirm --needed sublime-text-4
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed meld
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed nano
sudo pacman -S --noconfirm --needed fastfetch
sudo pacman -S --noconfirm --needed lolcat
sudo pacman -S --noconfirm --needed terminus-font
sudo pacman -S --noconfirm --needed bash-completion
sudo pacman -S --noconfirm --needed starship
sudo pacman -S --noconfirm --needed btop
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed sardi-flat-colora-variations-icons-git
sudo pacman -S --noconfirm --needed bibata-cursor-theme
sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed hwinfo
sudo pacman -S --noconfirm --needed lshw
sudo pacman -S --noconfirm --needed reflector
sudo pacman -S --noconfirm --needed expac
sudo pacman -S --noconfirm --needed sparklines-git
sudo pacman -S --noconfirm --needed downgrade
sudo pacman -S --noconfirm --needed betterlockscreen
sudo pacman -S --noconfirm --needed pamac-aur

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
        sudo pacman -S --noconfirm --needed qemu-guest-agent spice-vdagent
        sudo systemctl enable qemu-guest-agent.service
        ;;
    oracle)
        echo "Detected VirtualBox. Installing virtualbox-guest-utils..."
        sudo pacman -S --noconfirm --needed virtualbox-guest-utils
        sudo systemctl enable vboxservice.service
        ;;
    none)
        echo "No virtualization detected. Skipping guest utilities."
        ;;
    *)
        echo "Virtualization detected: $virt_type, but no install routine defined."
        ;;
esac

tput setaf 3
echo "################################################################"
echo "End base setup"
echo "################################################################"
tput sgr0

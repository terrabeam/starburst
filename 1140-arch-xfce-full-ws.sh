#!/bin/bash
#set -e
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

echo
tput setaf 2
echo "########################################################################"
echo "################### Install XFCE4 Full Workstation"
echo "########################################################################"
tput sgr0
echo

#editors
sudo pacman -S --noconfirm --needed code

#internet
sudo pacman -Rs --noconfirm chromium
sudo pacman -S --noconfirm --needed google-chrome brave-bin insync
#sudo pacman -S --noconfirm --needed discord firefox

#theming
#sudo pacman -S --noconfirm --needed variety

#media
#sudo pacman -S --noconfirm --needed gimp inkscape spotify lollypop
sudo pacman -S --noconfirm --needed flameshot-git vlc

#shells
sudo pacman -S --noconfirm --needed fish zsh zsh-completions zsh-syntax-highlighting oh-my-zsh-git

#system-tools
#sudo pacman -S --noconfirm --needed base-devel

#tools
#sudo pacman -S --noconfirm --needed gitahead-git
sudo pacman -S --noconfirm --needed wttr system-config-printer
sudo pacman -S --noconfirm --needed ripgrep meld btop htop hwinfo lshw reflector expac sublime-text-4
if [ ! -f /usr/bin/duf ]; then
  sudo pacman -S --noconfirm --needed duf
fi
sudo pacman -S --noconfirm --needed man-db man-pages pacmanlogviewer paru-git yay-git thunar thunar-archive-plugin thunar-volman tree xdg-user-dirs polkit-gnome rate-mirrors rsync time bat ntp nss-mdns

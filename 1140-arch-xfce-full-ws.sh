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
sudo pacman -S --noconfirm --needed google-chrome
sudo pacman -S --noconfirm --needed brave-bin
#sudo pacman -S --noconfirm --needed discord
#sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed insync

#theming
sudo pacman -S --noconfirm --needed variety

#media
#sudo pacman -S --noconfirm --needed gimp
#sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed flameshot-git
#sudo pacman -S --noconfirm --needed spotify
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed lollypop

#shells
sudo pacman -S --noconfirm --needed fish
sudo pacman -S --noconfirm --needed zsh
sudo pacman -S --noconfirm --needed zsh-completions
sudo pacman -S --noconfirm --needed zsh-syntax-highlighting
sudo pacman -S --noconfirm --needed oh-my-zsh-git

#system-tools
#sudo pacman -S --noconfirm --needed base-devel

#tools
sudo pacman -S --noconfirm --needed gitahead-git
sudo pacman -S --noconfirm --needed wttr
sudo pacman -S --noconfirm --needed system-config-printer

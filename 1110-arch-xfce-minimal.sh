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

##################################################################################################################################

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "#######################################################################################"
        echo "################## The package "$1" is already installed"
        echo "#######################################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "#######################################################################################"
        echo "##################  Installing package "  $1
        echo "#######################################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}

func_install_xfce4_min() {

    echo
    tput setaf 2
    echo "########################################################################"
    echo "################### Install XFCE4 Minimal"
    echo "########################################################################"
    tput sgr0
    echo

    list=(
    xfce4
    xfce4-goodies
    sddm
    )

    count=0

    for name in "${list[@]}" ; do
        count=$[count+1]
        tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
        func_install $name
    done
}

echo
tput setaf 2
echo "########################################################################"
echo "################### Let us install XFCE4 Minimal"
echo "########################################################################"
tput sgr0
echo

func_install_xfce4_min

echo
tput setaf 6
echo "##############################################################"
echo "###################  CLEANUP unwanted packages"
echo "##############################################################"
tput sgr0
echo

sudo pacman -Rs --noconfirm mousepad
sudo pacman -Rs --noconfirm parole
sudo pacman -Rs --noconfirm xfburn
sudo pacman -Rs --noconfirm xfce4-screenshooter
sudo pacman -Rs --noconfirm xfce4-notes-plugin

echo
tput setaf 2
echo "########################################################################"
echo "################### Configure XFCE4-settings"
echo "########################################################################"
tput sgr0
echo

#create some folders
[ -d /etc/skel/.config ] || sudo mkdir -p /etc/skel/.config
[ -d /etc/skel/.config/xfce4 ] || sudo mkdir -p /etc/skel/.config/xfce4
[ -d /etc/skel/.config/xfce4/panel ] || sudo mkdir -p /etc/skel/.config/xfce4/panel
[ -d /etc/skel/.config/xfce4/xfconf ] || sudo mkdir -p /etc/skel/.config/xfce4/xfconf

[ -d $HOME"/.bin" ] || mkdir -p $HOME"/.bin"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.local/share/icons" ] || mkdir -p $HOME"/.local/share/icons"
[ -d $HOME"/.local/share/themes" ] || mkdir -p $HOME"/.local/share/themes"
[ -d $HOME"/.local/share/applications" ] || mkdir -p $HOME"/.local/share/applications"
[ -d $HOME"/.config" ] || mkdir -p $HOME"/.config"
[ -d $HOME"/.config/xfce4" ] || mkdir -p $HOME"/.config/xfce4"
[ -d $HOME"/.config/autostart" ] || mkdir -p $HOME"/.config/autostart"
[ -d $HOME"/.config/xfce4/xfconf" ] || mkdir -p $HOME"/.config/xfce4/xfconf"
[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
[ -d $HOME"/.config/gtk-4.0" ] || mkdir -p $HOME"/.config/gtk-4.0"
[ -d $HOME"/.config/variety" ] || mkdir -p $HOME"/.config/variety"
[ -d $HOME"/.config/fish" ] || mkdir -p $HOME"/.config/fish"
[ -d $HOME"/.config/neofetch" ] || mkdir -p $HOME"/.config/neofetch"
[ -d $HOME"/DATA" ] || mkdir -p $HOME"/DATA"

echo
tput setaf 2
echo "########################################################################"
echo "################### Personal settings to install - any OS"
echo "########################################################################"
tput sgr0
echo

echo
echo "Enable fstrim timer"
sudo systemctl enable fstrim.timer

echo
tput setaf 6
echo "##############################################################"
echo "###################  Enabling SDDM"
echo "##############################################################"
tput sgr0
echo
sudo systemctl enable sddm.service

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
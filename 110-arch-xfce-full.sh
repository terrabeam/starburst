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

func_install_xfce4_full() {

    echo
    tput setaf 2
    echo "########################################################################"
    echo "################### Install XFCE4 Full"
    echo "########################################################################"
    tput sgr0
    echo

    list=(
    meld
    code
    chromium
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
echo "################### Let us install XFCE4 Full"
echo "########################################################################"
tput sgr0
echo
    
func_install_xfce4_full

echo
tput setaf 2
echo "########################################################################"
echo "################### Configure XFCE4-settings"
echo "########################################################################"
tput sgr0
echo

echo
echo "Setting Default Applications"
echo
sudo cp -rf $installed_dir/assets/xfce4/ /etc/skel/.config/
sudo cp $installed_dir/assets/mimeapps.list /etc/skel/.config/mimeapps.list

echo
echo "Setting bashrc"
echo
sudo cp -v /etc/skel/.bashrc /etc/skel/.bashrc.starburst
sudo cp -rf $installed_dir/assets/.bashrc /etc/skel/.bashrc

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
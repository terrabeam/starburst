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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

echo
tput setaf 3
echo "################################################################"
echo "################### Remove unwanted packages"
echo "################################################################"
tput sgr0
echo

tput setaf 1;
  echo "###############################################################################"
  echo "###      - KEEP LINUX KERNEL GET RID OF THE OTHER KERNELS"
  echo "###      - GET RID OF BROADCOM AND REALTEK DRIVERS"
  echo "###############################################################################"
  tput sgr0
  
read -n1 -r -p "Press any key to continue..." key

  echo
  echo "############################################################"
  echo " Remaining installed kernels:"
  echo "############################################################"

  # List installed kernel images
  dpkg -l | grep '^ii' | grep 'linux-image-[0-9]' | awk '{print $2, $3}'

  echo
  echo "Currently running kernel: $(uname -r)"

read -n1 -r -p "Press any key to continue..." key

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing the drivers"
  echo "########################################################################"
  tput sgr0
  echo

  sudo apt-get purge -y \
      xserver-xorg-video-amdgpu \
      xserver-xorg-video-ati \
      xserver-xorg-video-fbdev \
      xserver-xorg-video-nouveau \
      xserver-xorg-video-openchrome \
      xserver-xorg-video-vesa
  sudo apt-get autoremove -y

read -n1 -r -p "Press any key to continue..." key

  sudo systemctl disable --now tlp.service
  sudo apt-get purge -y tlp
  sudo apt-get autoremove -y

read -n1 -r -p "Press any key to continue..." key

  sudo apt-get purge -y vim vim-runtime vim-common vim-tiny
  sudo apt-get autoremove -y
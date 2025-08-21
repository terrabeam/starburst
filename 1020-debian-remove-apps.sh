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
  echo "###      - GET RID OF CONKYS"
  echo "###############################################################################"
  tput sgr0
  
  #######broadcom and realtek
  sudo apt-get purge -y broadcom-sta-dkms r8168-dkms rtl8821cu-dkms
  sudo apt-get autoremove -y
  
  # Ensure at least one kernel (linux-image-amd64 + linux-headers-amd64) remains
  if dpkg -l | grep -q "^ii  linux-image-amd64" && dpkg -l | grep -q "^ii  linux-headers-amd64"; then

      # Define kernels/headers you want to remove (common Debian flavors)
      KERNELS_TO_REMOVE=(
          linux-image-rt-amd64 linux-headers-rt-amd64
          linux-image-cloud-amd64 linux-headers-cloud-amd64
          linux-image-unsigned-* linux-headers-unsigned-*
          linux-image-xanmod linux-headers-xanmod
      )

      remove_package() {
          local package=$1
          # Check if package is installed
          if dpkg -l | grep -q "^ii  $package"; then
              echo "$package is installed. Removing..."
              sudo apt-get purge -y "$package"
          else
              echo "$package is not installed."
          fi
      }

      # Loop over list and remove
      for kernel in "${KERNELS_TO_REMOVE[@]}"; do
          remove_package "$kernel"
      done

      # Clean up unused dependencies
      sudo apt-get autoremove -y

  else
      echo "Cannot proceed: At least one kernel must remain installed."
  fi

  echo
  echo "############################################################"
  echo " Remaining installed kernels:"
  echo "############################################################"

  # List installed kernel images
  dpkg -l | grep '^ii' | grep 'linux-image-[0-9]' | awk '{print $2, $3}'

  echo
  echo "Currently running kernel: $(uname -r)"



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

  sudo systemctl disable --now tlp.service
  sudo apt-get purge -y tlp
  sudo apt-get autoremove -y

  sudo apt-get purge -y vim vim-runtime vim-common vim-tiny
  sudo apt-get autoremove -y
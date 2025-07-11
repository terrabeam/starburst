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
  sudo pacman -Rs broadcom-wl-dkms r8168-dkms rtl8821cu-morrownr-dkms-git --noconfirm
  
  # Ensure at least one kernel remains
  if pacman -Qi linux &> /dev/null && pacman -Qi linux-headers &> /dev/null; then
  
      # Define all the kernels and their headers you want to remove
      KERNELS_TO_REMOVE=(
           linux-lts-headers linux-lts
           linux-zen-headers linux-zen
           linux-hardened-headers linux-hardened
           linux-rt-headers linux-rt
           linux-rt-lts-headers linux-rt-lts
           linux-cachyos-headers linux-cachyos
           linux-xanmod-headers linux-xanmod
      )
      remove_package() {
          local package=$1
          # Check if the package is installed
          if pacman -Q $package &> /dev/null; then
              echo "$package is installed. Removing..."
              sudo pacman -Rns --noconfirm $package
          else
              echo "$package is not installed."
          fi
      }
  
      # Loop over the array and remove each kernel package
      for kernel in "${KERNELS_TO_REMOVE[@]}"; do
          remove_package "$kernel"
      done
  
  else
      echo "Cannot proceed: At least one kernel must remain installed."
  fi

  #######conkys
  # Array of packages to check
  packages=("conky-lua-archers" "arcolinux-conky-collection-git" "arcolinux-conky-collection-plasma-git")  
  
  # Function to check if a package is installed
  is_package_installed() {
      if pacman -Q "$1" &> /dev/null; then
          echo "Package $1 is installed."
          return 0  # Success
      else
          echo "Package $1 is not installed."
          return 1  # Failure
      fi
  }
  
  # Iterate over each package in the array
  for package in "${packages[@]}"; do
      if is_package_installed "$package"; then
          echo "Removing $package..."
          sudo pacman -Rns "$package" --noconfirm
      else
          echo "$package is not installed, no need to remove."
      fi
      echo
      echo "########################"
      echo "Double checking $package"
      echo "########################"
      echo
      if ! is_package_installed "$package"; then
          echo "$package is not installed!"
      else
          echo "$package is still installed. Check manually why not."
      fi
  done

  echo
  tput setaf 3
  echo "########################################################################"
  echo "######## Removing the drivers"
  echo "########################################################################"
  tput sgr0
  echo

  sudo pacman -Rs --noconfirm xf86-video-amdgpu --noconfirm
  sudo pacman -Rs --noconfirm xf86-video-ati --noconfirm
  sudo pacman -Rs --noconfirm xf86-video-fbdev --noconfirm
  sudo pacman -Rs --noconfirm xf86-video-nouveau --noconfirm
  sudo pacman -Rs --noconfirm xf86-video-openchrome --noconfirm
  sudo pacman -Rs --noconfirm xf86-video-vesa --noconfirm

  sudo systemctl disable tlp.service
  sudo pacman -Rs tlp --noconfirm

  sudo pacman -Rs vim vim-runtime --noconfirm


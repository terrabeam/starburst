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

# Setting installed_dir to base folder of the git-repository
installed_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Installing chaotic-aur keys and mirrors
pkg_dir="packages"

# Ensure directory exists
if [[ ! -d "$pkg_dir" ]]; then
    echo "Directory not found: $pkg_dir"
    exit 1
fi

# Install all local packages using pacman
find "$pkg_dir" -maxdepth 1 -name '*.pkg.tar.zst' -print0 | sudo xargs -0 pacman -U --noconfirm


# personal pacman.conf
if [[ ! -f /etc/pacman.conf.starburst ]]; then
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Copying /etc/pacman.conf to /etc/pacman.conf.starburst"
    echo "################################################################################"
    tput sgr0
    echo
    sudo cp -v /etc/pacman.conf /etc/pacman.conf.starburst
    echo
else
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Backup already exists: /etc/pacman.conf.starburst"
    echo "################################################################################"
    tput sgr0
    echo
fi

sudo cp -v $installed_dir/config-files/pacman.conf /etc/pacman.conf

echo
tput setaf 2
echo "################################################################################"
echo "Updating the system - sudo pacman -Syyu"
echo "################################################################################"
tput sgr0
echo

sudo pacman -Syyu --noconfirm

echo
tput setaf 3
echo "########################################################################"
echo "Which desktop environment do you want to install?"
echo "Choose one of the following options:"
echo
echo "1) XFCE4 minimal"
echo "2) XFCE4 full"
echo "3) Plasma minimal"
echo "4) Plasma full"
echo "X) None"
echo "########################################################################"
tput sgr0
echo

read -r -p "Enter the number of your choice: " choice

case "$choice" in
    1)
        touch /tmp/install-xfce4-minimal
        ;;
    2)
        touch /tmp/install-xfce4-full
        ;;
    3)
        touch /tmp/install-plasma-minimal
        ;;
    4)
        touch /tmp/install-plasma-full
        ;;
    [Xx])
        echo "No desktop environment will be installed."
        ;;
    *)
        tput setaf 1
        echo "Invalid choice. Exiting."
        tput sgr0
        exit 1
        ;;
esac

echo
tput setaf 3
echo "########################################################################"
echo "Would you like to install an additional Tiling Window Manager?"
echo "Choose one of the following options:"
echo
echo "1) CHADWM"
echo "2) Hyprland (not possible on VM)"
echo "X) None"
echo "########################################################################"
tput sgr0
echo

read -p "Enter the number of your choice: " choice

case "$choice" in
    1)
        touch /tmp/install-chadwm
        ;;
    2)
        touch /tmp/install-hyprland
        ;;
    [Xx])
        echo "No desktop environment will be installed."
        ;;
    *)
        tput setaf 1
        echo "Invalid choice. Exiting."
        tput sgr0
        exit 1
        ;;
esac

tput setaf 1;
  echo "###############################################################################"
  echo "###      SCRIPT TO REMOVE ELEMENTS WITH NO QUESTIONS ASKED"
  echo "###"
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

tput setaf 3
echo "################################################################"
echo "Starting installation of chosen Desktop Environment"
echo "################################################################"
tput sgr0

if [ -f /tmp/install-xfce4-minimal ]; then
    sh 110-arch-xfce-minimal*
fi

if [ -f /tmp/install-xfce4-full ]; then
    sh 110-arch-xfce-minimal*
    sh 110-arch-xfce-full*
fi

if [ -f /tmp/install-plasma-minimal ]; then
    sh 110-arch-plasma-minimal*
fi

if [ -f /tmp/install-plasma-full ]; then
    sh 110-arch-plasma-minimal*
    sh 110-arch-plasma-full*
fi

# installation of Tiling Window Managers
if [ -f /tmp/install-chadwm ]; then
    sh 120-arch-chadwm*
fi

if [ -f /tmp/install-hyprland ]; then
    sh 120-arch-hyprland*
fi

tput setaf 3
echo "################################################################"
echo "Cleaning up"
echo "################################################################"
tput sgr0

rm -f /tmp/install-*

tput setaf 3
echo "################################################################"
echo "End Arch setup"
echo "################################################################"
tput sgr0

### Run final scripts
sh 990-skel.sh

### DONE
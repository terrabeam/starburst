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

#firmwares
sudo pacman -S --noconfirm --needed aic94xx-firmware linux-firmware-qlogic upd72020x-fw wd719x-firmware mkinitcpio-firmware


#fonts
sudo pacman -S --noconfirm --needed font-manager adobe-source-sans-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family terminus-font awesome-terminal-fonts

#tools
sudo pacman -S --noconfirm --needed ripgrep meld wget curl nano fastfetch lolcat bash-completion starship btop htop alacritty hwinfo lshw reflector expac sparklines-git downgrade betterlockscreen pamac-aur sublime-text-4 avahi
if [ ! -f /usr/bin/duf ]; then
  sudo pacman -S --noconfirm --needed duf
fi
sudo pacman -S --noconfirm --needed man-db man-pages pacmanlogviewer paru-git yay-git thunar thunar-archive-plugin thunar-volman tree xdg-user-dirs polkit-gnome rate-mirrors rsync time bat ntp nss-mdns

#disk-tools
sudo pacman -S --noconfirm --needed baobab gnome-disk-utility gvfs-smb hddtemp squashfs-tools
#sudo pacman -S --noconfirm --needed gvfs-dnssd
#sudo pacman -S --noconfirm --needed the_silver_searcher

#archive-managers
sudo pacman -S --noconfirm --needed zip gzip p7zip unace unrar unzip file-roller

#theming
sudo pacman -S --noconfirm --needed bibata-cursor-theme-bin feh
#sudo pacman -S --noconfirm --needed breeze-icons sardi-flat-colora-variations-icons-git

#enable services
sudo systemctl enable avahi-daemon.service
sudo systemctl enable ntpd.service

#Run service that will discard unused blocks on mounted filesystems. This is useful for solid-state drives (SSDs) and thinly-provisioned storage. 
echo
echo "Enable fstrim timer"
sudo systemctl enable fstrim.timer

echo
echo "################################################################"
echo "Getting latest /etc/nsswitch.conf"
echo "################################################################"
echo
sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
sudo wget https://raw.githubusercontent.com/yurikuit/nemesis/refs/heads/main/Personal/settings/nsswitch/nsswitch.conf -O $workdir/etc/nsswitch.conf


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

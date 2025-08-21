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
echo "################### Start Arch setup"
echo "################################################################"
tput sgr0
echoþ

echo
tput setaf 2
echo "################################################################################"
echo "Installing much needed software"
echo "################################################################################"
tput sgr0
echo

#firmwares
sudo apt-get install -y firmware-linux firmware-linux-nonfree firmware-misc-nonfree

#fonts
sudo apt install -y font-manager adobe-source-sans-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family terminus-font awesome-terminal-fonts ttf-jetbrains-mono-nerd

#tools
sudo apt install -y wget curl nano fastfetch lolcat bash-completion starship alacritty hwinfo lshw reflector expac betterlockscreen pamac-aur avahi
if [ ! -f /usr/bin/duf ]; then
  sudo apt install -y duf
fi
sudo apt install -y man-db man-pages thunar thunar-archive-plugin thunar-volman tree xdg-user-dirs polkit-gnome rate-mirrors rsync time bat ntp nss-mdns

#disk-tools
sudo apt install -y gvfs-smb squashfs-tools

#archive-managers
sudo apt install -y zip gzip p7zip unace unrar unzip file-roller

#theming
sudo apt install -y bibata-cursor-theme-bin feh

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
        sudo apt install -y qemu-guest-agent spice-vdagent
        sudo systemctl enable qemu-guest-agent.service
        ;;
    oracle)
        echo "Detected VirtualBox. Installing virtualbox-guest-utils..."
        sudo apt install -y virtualbox-guest-utils
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

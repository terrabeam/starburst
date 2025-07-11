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
sudo pacman -S --noconfirm --needed aic94xx-firmware
sudo pacman -S --noconfirm --needed linux-firmware-qlogic
sudo pacman -S --noconfirm --needed upd72020x-fw
sudo pacman -S --noconfirm --needed wd719x-firmware
sudo pacman -S --noconfirm --needed mkinitcpio-firmware

#fonts
sudo pacman -S --noconfirm --needed font-manager
sudo pacman -S --noconfirm --needed adobe-source-sans-fonts
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed ttf-bitstream-vera
sudo pacman -S --noconfirm --needed ttf-dejavu
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed ttf-hack
sudo pacman -S --noconfirm --needed ttf-inconsolata
sudo pacman -S --noconfirm --needed ttf-liberation
sudo pacman -S --noconfirm --needed ttf-roboto
sudo pacman -S --noconfirm --needed ttf-roboto-mono
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed terminus-font
sudo pacman -S --noconfirm --needed awesome-terminal-fonts

#tools
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed meld
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed nano
sudo pacman -S --noconfirm --needed fastfetch
sudo pacman -S --noconfirm --needed lolcat
sudo pacman -S --noconfirm --needed bash-completion
sudo pacman -S --noconfirm --needed starship
sudo pacman -S --noconfirm --needed btop
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed hwinfo
sudo pacman -S --noconfirm --needed lshw
sudo pacman -S --noconfirm --needed reflector
sudo pacman -S --noconfirm --needed expac
sudo pacman -S --noconfirm --needed sparklines-git
sudo pacman -S --noconfirm --needed downgrade
sudo pacman -S --noconfirm --needed betterlockscreen
sudo pacman -S --noconfirm --needed pamac-aur
sudo pacman -S --noconfirm --needed sublime-text-4
sudo pacman -S --noconfirm --needed avahi
if [ ! -f /usr/bin/duf ]; then
  sudo pacman -S --noconfirm --needed duf
fi
sudo pacman -S --noconfirm --needed man-db
sudo pacman -S --noconfirm --needed man-pages
sudo pacman -S --noconfirm --needed pacmanlogviewer
sudo pacman -S --noconfirm --needed paru-git
sudo pacman -S --noconfirm --needed yay-git
sudo pacman -S --noconfirm --needed thunar
sudo pacman -S --noconfirm --needed thunar-archive-plugin
sudo pacman -S --noconfirm --needed thunar-volman
sudo pacman -S --noconfirm --needed tree
sudo pacman -S --noconfirm --needed xdg-user-dirs
sudo pacman -S --noconfirm --needed polkit-gnome
sudo pacman -S --noconfirm --needed rate-mirrors
sudo pacman -S --noconfirm --needed rsync
sudo pacman -S --noconfirm --needed time
sudo pacman -S --noconfirm --needed bat
sudo pacman -S --noconfirm --needed ntp
sudo pacman -S --noconfirm --needed nss-mdns

#disk-tools
sudo pacman -S --noconfirm --needed baobab
sudo pacman -S --noconfirm --needed gnome-disk-utility
sudo pacman -S --noconfirm --needed gvfs-smb
#sudo pacman -S --noconfirm --needed gvfs-dnssd
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed squashfs-tools
#sudo pacman -S --noconfirm --needed the_silver_searcher

#archive-managers
sudo pacman -S --noconfirm --needed zip
sudo pacman -S --noconfirm --needed gzip
sudo pacman -S --noconfirm --needed p7zip
sudo pacman -S --noconfirm --needed unace
sudo pacman -S --noconfirm --needed unrar
sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed file-roller

#theming
sudo pacman -S --noconfirm --needed sardi-flat-colora-variations-icons-git
sudo pacman -S --noconfirm --needed bibata-cursor-theme-bin
#sudo pacman -S --noconfirm --needed breeze-icons
sudo pacman -S --noconfirm --needed feh

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

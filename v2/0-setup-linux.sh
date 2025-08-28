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
echo "################### Start OS Detection"
echo "################################################################"
tput sgr0
echo

# Parse /etc/os-release
source /etc/os-release

OS_ID=${ID,,}
OS_LIKE=${ID_LIKE,,}
OS_VERSION="$VERSION_ID"
OS_PRETTY="$PRETTY_NAME"

OS=""

# Detect distro
case "$OS_ID" in
    arch)   OS="arch" ;;
    debian) OS="debian" ;;
    ubuntu) OS="ubuntu" ;;
    fedora) OS="fedora" ;;
    *)
        if [[ "$OS_LIKE" == *"arch"* ]]; then
            OS="arch"
        elif [[ "$OS_LIKE" == *"debian"* ]]; then
            OS="debian"
        elif [[ "$OS_LIKE" == *"fedora"* || "$OS_LIKE" == *"rhel"* ]]; then
            OS="fedora"
        fi
        ;;
esac

# Print detection
if [[ -n "$OS" ]]; then
    tput setaf 6
    echo "################################################################################"
    echo "Detected OS: $OS ($OS_PRETTY)"
    echo "Version: $OS_VERSION"
    echo "################################################################################"
    tput sgr0
else
    tput setaf 1
    echo "################################################################################"
    echo "ERROR: Unsupported or unknown Linux distribution."
    echo "Detected: ID=$OS_ID, ID_LIKE=$OS_LIKE"
    echo "################################################################################"
    tput sgr0
    exit 1
fi

#####################################################
# Desktop Environment detection
#####################################################
echo
tput setaf 3
echo "################################################################"
echo "################### Start DE Detection"
echo "################################################################"
tput sgr0
echo

DE_RAW="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}"
DE=""

# Normalize values
case "${DE_RAW,,}" in
    *xfce*)          DE="xfce" ;;
    *plasma*|*kde*)  DE="plasma" ;;
    *gnome*)         DE="gnome" ;;
    ""|none)         DE="none" ;;   # explicitly allow headless
esac

# Print DE detection
if [[ -n "$DE" ]]; then
    tput setaf 6
    echo "################################################################################"
    echo "Detected Desktop Environment: $DE (${DE_RAW:-none})"
    echo "################################################################################"
    tput sgr0
else
    tput setaf 1
    echo "################################################################################"
    echo "ERROR: Unsupported or unknown Desktop Environment."
    echo "Allowed: XFCE, Plasma, GNOME, None"
    echo "Detected: ${DE_RAW:-empty}"
    echo "################################################################################"
    tput sgr0
    exit 1
fi

#####################################################
# Run per-distro + DE setup
#####################################################
case "$OS" in
    arch)
        echo "Running Arch + $DE setup..."
        [[ -x "./arch-${DE}.sh" ]] && "./arch-${DE}.sh" || { echo "Missing: arch-${DE}.sh"; exit 1; }
        ;;
    debian)
        echo "Running Debian + $DE setup..."
        [[ -x "./debian-${DE}.sh" ]] && "./debian-${DE}.sh" || { echo "Missing: debian-${DE}.sh"; exit 1; }
        ;;
    ubuntu)
        echo "Running Ubuntu + $DE setup..."
        [[ -x "./ubuntu-${DE}.sh" ]] && "./ubuntu-${DE}.sh" || { echo "Missing: ubuntu-${DE}.sh"; exit 1; }
        ;;
    fedora)
        echo "Running Fedora + $DE setup..."
        [[ -x "./fedora-${DE}.sh" ]] && "./fedora-${DE}.sh" || { echo "Missing: fedora-${DE}.sh"; exit 1; }
        ;;
esac

tput setaf 3
echo "################################################################"
echo "End Detection"
echo "################################################################"
tput sgr0

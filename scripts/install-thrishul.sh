#!/usr/bin/env bash

set -euo pipefail

#########################################
# Project Thrishul Installer
# Version: 0.1 Alpha
#########################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

THRISHUL_VERSION="0.1 Alpha"

echo -e "${GREEN}"
echo "======================================================"
echo "             Project Thrishul Installer"
echo "             Version ${THRISHUL_VERSION}"
echo "======================================================"
echo -e "${NC}"

#########################################
# Verify Fedora
#########################################

if ! grep -qi fedora /etc/os-release; then
    echo -e "${RED}This installer supports Fedora only.${NC}"
    exit 1
fi

#########################################
# Refresh Repositories
#########################################

echo -e "${BLUE}[1/8] Refreshing repositories...${NC}"

sudo dnf upgrade --refresh -y

#########################################
# RPM Fusion
#########################################

echo -e "${BLUE}[2/8] Enabling RPM Fusion...${NC}"

sudo dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#########################################
# Desktop Packages
#########################################

DESKTOP=(
    hyprland
    waybar
    kitty
    wofi
    mako
    grim
    slurp
    wl-clipboard
)

#########################################
# Core Tools
#########################################

CORE=(
    git
    curl
    wget
    neovim
    btop
    tmux
    unzip
)
#########################################
# Cybersecurity Tools
#########################################

SECURITY=(
    wireshark
    tcpdump
    suricata
    zeek
    yara
)

#########################################
# Containers
#########################################

CONTAINERS=(
    podman
    distrobox
)

#########################################
# Recovery
#########################################

RECOVERY=(
    snapper
)
#########################################
# System Security
#########################################

SYSTEM=(
    firewalld
)

#########################################
# Install Packages
#########################################

echo -e "${BLUE}[3/8] Installing Thrishul packages...${NC}"

ALL_PACKAGES=(
"${DESKTOP[@]}"
"${CORE[@]}"
"${SECURITY[@]}"
"${CONTAINERS[@]}"
"${RECOVERY[@]}"
"${SYSTEM[@]}"
)

sudo dnf install -y "${ALL_PACKAGES[@]}"

#########################################
# Enable Services
#########################################

echo -e "${BLUE}[4/8] Configuring services...${NC}"

sudo systemctl enable firewalld
sudo systemctl start firewalld

#########################################
# Wireshark Permissions
#########################################

echo -e "${BLUE}[5/8] Configuring Wireshark...${NC}"

if getent group wireshark >/dev/null; then
    sudo usermod -aG wireshark "$USER"
fi

#########################################
# NVIDIA Prompt
#########################################

echo -e "${BLUE}[6/8] NVIDIA Support${NC}"

read -rp "Install NVIDIA drivers? (y/N): " NVIDIA

if [[ "$NVIDIA" =~ ^[Yy]$ ]]; then

    sudo dnf install -y \
    akmod-nvidia \
    xorg-x11-drv-nvidia \
    xorg-x11-drv-nvidia-cuda

fi

#########################################
# SELinux Check
#########################################

echo -e "${BLUE}[7/8] Checking SELinux...${NC}"

getenforce

#########################################
# Cleanup
#########################################

echo -e "${BLUE}[8/8] Cleaning package cache...${NC}"

sudo dnf clean all

echo
echo -e "${GREEN}"
echo "======================================================"
echo "     Project Thrishul Installation Completed"
echo "======================================================"
echo
echo "Next Steps:"
echo "1. Reboot"
echo "2. Login to Hyprland"
echo "3. Verify Wireshark permissions"
echo "4. Configure Snapper"
echo
echo "Welcome to Project Thrishul."
echo -e "${NC}"

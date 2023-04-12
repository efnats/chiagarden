#!/bin/bash

# Description: Installer script for ChiaGarden - a set of Linux tools to build and manage a Chia post farm.

# Clear the terminal
clear

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}This script must be run as root${NC}" 
  exit 1
fi

# Print header
echo -e "${GREEN}ChiaGarden Installer${NC}"
echo "----------------------------------"

# Prompt user for confirmation
read -p "This script will install ChiaGarden and its dependencies. Do you want to proceed? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo -e "${RED}Installation canceled.${NC}"
  exit 1
fi

# Update package list and install dependencies
echo -e "\n${YELLOW}Updating package list and installing dependencies...${NC}"
apt update
apt install -y mergerfs xfsprogs ntfs-3g smartmontools parted

# Copy files
echo -e "\n${YELLOW}Copying ChiaGarden files...${NC}"
files_to_copy=(
  "./chiainit/chiainit"
  "./garden-mount/gardenmount"
  "./plotting/plot_counter"
  "./plotting/plot_mover"
  "./plotting/plot_over"
  "./plotting/plot_starter"
  "./taco_list/taco_list"
)

for file in "${files_to_copy[@]}"; do
  if [[ -e $file ]]; then
    cp $file /usr/local/bin/
    echo -e "${GREEN}Copied${NC} $file ${GREEN}to /usr/local/bin/${NC}"
  else
    echo -e "${RED}Error: File $file not found${NC}"
    exit 1
  fi
done

# Copy the systemd service
if [[ -e "garden-mount/garden-mount.service" ]]; then
  echo -e "\n${YELLOW}Copying the garden-mount.service file...${NC}"
  cp ./garden-mount/garden-mount.service /etc/systemd/system/
else
  echo -e "${RED}Error: garden-mount.service not found${NC}"
  exit 1
fi

# Prompt user to enable the systemd service
echo -e "\n${YELLOW}The garden-mount.service manages your drive mounts and mergerfs. More info in the readme files.${NC}"
read -p "Do you want to automatically start the garden-mount.service upon boot? [y/N] " enable_response
if [[ "$enable_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo -e "\n${GREEN}Enabling the garden-mount service...${NC}"
  systemctl daemon-reload
  systemctl enable garden-mount.service
fi

# Prompt user to start the systemd service
read -p "Do you want to start the garden-mount systemd service now? [y/N] " start_response
if [[ "$start_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo -e "\n${GREEN}Starting the garden-mount service...${NC}"
  systemctl start garden-mount.service
fi

echo -e "\n${GREEN}ChiaGarden installation complete!${NC}\n"

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

read -p "This script will install ChiaGarden and its dependencies. Do you want to proceed? [Y/n] " response
if [[ "$response" =~ ^([nN][oO]|[nN])$ ]]; then
  echo -e "${RED}Installation canceled.${NC}"
  exit 1
fi

# Array of full paths for old program files that have been renamed or are no longer needed
obsolete_program_names=(
    "/usr/local/bin/plot_avg"
    # Add the full path for more old program files as needed
)

# Remove old program files
remove_obsolete_program_names() {
    for file_renamed in "${obsolete_program_names[@]}"; do
        if [[ -e $file_renamed ]]; then
            echo -e "${YELLOW}Migrating $file_renamed..${NC}"
            rm "$file_renamed"
        else
            echo -e "${RED}$file_renamed no migration needed.${NC}"
        fi
    done
}


# Call the function to clean up old programs
remove_obsolete_program_names

apt update
apt install -y curl lsb-release xfsprogs ntfs-3g smartmontools parted python3 python3-pip


install_or_update_mergerfs() {
    # Get the OS release name
    os_release=$(lsb_release -cs)

    # Determine CPU architecture
    cpu_arch=$(uname -m)
    if [ "$cpu_arch" == "x86_64" ]; then
        cpu_arch="amd64"
    fi

    # Fetch the latest version from GitHub
    latest_version=$(curl -s "https://api.github.com/repos/trapexit/mergerfs/releases/latest" | grep tag_name | cut -d '"' -f 4 | tr -d 'v')

    # Create a URL based on detected OS release and CPU architecture
    url="https://github.com/trapexit/mergerfs/releases/download/${latest_version}/mergerfs_${latest_version}.ubuntu-${os_release}_${cpu_arch}.deb"

    # Download the .deb file
    echo "Downloading mergerfs from $url..."
    curl -L $url -o /tmp/mergerfs.deb

    # Check if the download was successful
    if [ $? -ne 0 ]; then
        echo "Error downloading the .deb file from GitHub. Falling back to package maintainer's version."
        sudo apt-get update
        sudo apt-get install -y mergerfs
        if [ $? -ne 0 ]; then
            echo "Error installing mergerfs from the package repository. Exiting."
            exit 1
        fi
    else
        # Install the .deb file
        echo "Installing mergerfs..."
        sudo dpkg -i /tmp/mergerfs.deb
        rm /tmp/mergerfs.deb
    fi

    echo "Installation or update completed."
}

# Install or update mergerfs
echo -e "\n${YELLOW}Installing mergerfs...${NC}"
install_or_update_mergerfs

# Update package list and install dependencies
echo -e "\n${YELLOW}Updating package list and installing dependencies...${NC}"
apt install -y $DEPENDENCIES

# Install necessary Python packages using pip3
echo -e "\n${YELLOW}Installing required Python packages...${NC}"
pip3 install colorama
pip3 install requests

# Create /etc/chiagarden directory if it doesn't exist
echo -e "\n${YELLOW}Checking for /etc/chiagarden directory...${NC}"
if [[ ! -d /etc/chiagarden ]]; then
    echo -e "${YELLOW}Creating /etc/chiagarden directory...${NC}"
    mkdir /etc/chiagarden
    echo -e "${GREEN}/etc/chiagarden directory created.${NC}"
else
    echo -e "${GREEN}/etc/chiagarden directory already exists.${NC}"
fi


# Copy files
echo -e "\n${YELLOW}Copying ChiaGarden files...${NC}"
files_to_copy=(
  "./chiainit/chiainit"
  "./gardenmount/gardenmount"
  "./cropgains/cropgains"
  "./plotting/plot_counter"
  "./plotting/plot_mover"
  "./plotting/plot_over"
  "./plotting/plot_starter"
  "./plotting/plot_timer"
  "./plotting/plot_cleaner"
  "./plotting/plotsink.sh"
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
echo

# Function to download and set permissions (needed for plot_starter)
echo -e "${YELLOW}Downloading and setting permissions for plot_starter...${NC}"
download_and_set_permissions() {
    local file_url="$1"
    local file_name="$2"

    if [[ ! -e /usr/local/bin/$file_name ]]; then
        echo -e "${YELLOW}${file_name} not found. Downloading the latest version from GitHub...${NC}"

        # Download the file directly using the provided URL
        curl -L -o "/usr/local/bin/${file_name}" "$file_url"

        # After downloading, give execute permissions
        chmod +x "/usr/local/bin/${file_name}"

        echo -e "${GREEN}${file_name} downloaded and saved to /usr/local/bin/${NC}"
    else
        echo -e "${GREEN}${file_name} already exists in /usr/local/bin/${NC}"
    fi
}

echo -e "${YELLOW}Downloading from https://github.com/madMAx43v3r. Required for plot_starter...${NC}"
# Direct URL and file names
download_and_set_permissions "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/cuda-plotter/linux/x86_64/cuda_plot_k32" "cuda_plot_k32"
download_and_set_permissions "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/plot-sink/linux/x86_64/chia_plot_copy" "chia_plot_copy"
download_and_set_permissions "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/plot-sink/linux/x86_64/chia_plot_sink" "chia_plot_sink"


# Copy the systemd services
echo -e "\n${YELLOW}Copying systemd services...${NC}"
if [[ -e "gardenmount/garden-mount.service" ]]; then
  echo -e "\n${YELLOW}Installing garden-mount.service${NC}"
  cp ./gardenmount/garden-mount.service /etc/systemd/system/
else
  echo -e "\n${RED}Error: garden-mount.service not found${NC}"
  exit 1
fi

if [[ -e "plotting/plot-starter.service" ]]; then
  echo -e "${YELLOW}Installing plot-starter.service${NC}"
  cp ./plotting/plot-starter.service /etc/systemd/system/
else
  echo -e "${RED}Error: plot-starter.service not found${NC}"
  exit 1
fi

if [[ -e "plotting/plotsink.service" ]]; then
  echo -e "${YELLOW}Installing plotsink.service${NC}"
  cp ./plotting/plotsink.service /etc/systemd/system/
else
  echo -e "${RED}Error: plotsink.service not found${NC}"
  exit 1
fi


# Prompt user to enable the systemd service
echo
read -p "Do you want to enable the garden-mount service? (Automount drives during boot) [Y/n] " enable_response
if [[ ! "$enable_response" =~ ^([nN][oO]|[nN])$ ]]; then
  echo -e "${YELLOW}Enabling the garden-mount service...${NC}"
  systemctl daemon-reload
  systemctl enable garden-mount.service
fi


echo
read -p "Do you want to enable the plot-starter service? (Start plotting upon boot) [y/N] " enable_response
if [[ "$enable_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo -e "\n${YELLOW}Enabling the plot-starter service...${NC}"
  systemctl daemon-reload
  systemctl enable plot-starter.service
fi

echo
read -p "Do you want to enable the plotsink service? (Start MadMax's Plotsink on port 1337 during boot) [Y/n] " enable_response
if [[ ! "$enable_response" =~ ^([nN][oO]|[nN])$ ]]; then
  echo -e "${YELLOW}Enabling the plotsink service...${NC}"
  systemctl daemon-reload
  systemctl enable garden-mount.service
fi

echo -e
echo -e "${BOLD}${GREEN}ChiaGarden installation complete!${NC}"
echo -e "Please read the README.md files for more information on how to use ChiaGarden.\n"
echo -e "${YELLOW}You may want to start by using chiainit to initialize your drives.${NC}\n"

/usr/local/bin/chiainit --help
echo

#!/bin/bash

# Description: Installer script for ChiaGarden - a set of Linux tools to build and manage a Chia post farm.

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define file migrations
declare -A files_to_migrate=(
    ["/usr/local/bin/plot_avg"]="/usr/local/bin/plot_timer"
    #["/path/to/old_file2"]=""
)

# Define service migrations
declare -A services_to_migrate=(
    ["plot-starter.service"]="plot_starter.service"
    ["garden-mount.service"]="gardenmount.service"
)



# Check for root privileges
check_root() {
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}This script must be run as root${NC}" 
  exit 1
fi
}

print_header() {
# # ASCII art for the ChiaGarden logo
# cat << "EOF"
#  __ .      .__         .      
# /  `|_ * _.[ __ _.._. _| _ ._ 
# \__.[ )|(_][_./(_][  (_](/,[ )
# EOF
# echo "_______________________________"
  echo -e
  echo -e "${GREEN}ChiaGarden Installer${NC}"
  echo -e
  echo -e "Installing ChiaGarden and its dependencies."
  echo -e "To cancel at any time, press ${YELLOW}Ctrl+C${NC}."
  echo
  read -p "Proceed? [Y/n] " -r -e -i "Y" proceed_response

  if [[ ! "$proceed_response" =~ ^([yY][eE][sS]|[yY])?$ ]]; then
    echo -e "${YELLOW}Installation cancelled. Exiting now.${NC}"
    exit 1
  fi
}

migrate_files() {
    local array_name=$1
    declare -n file_pairs=$array_name
    local migration_found=false

    #echo "Checking for migration candidates of files..."

    for old_file in "${!file_pairs[@]}"; do
        new_file=${file_pairs[$old_file]}

        if [ -f "$old_file" ]; then
            migration_found=true
            if [ -n "$new_file" ]; then
                mv "$old_file" "$new_file"
                echo "Renamed $old_file to $new_file"
            else
                rm "$old_file"
                echo "Removed $old_file"
            fi
        fi
    done

    if [ "$migration_found" = false ]; then
        echo "No migration required for files."
    fi
}



migrate_service_files() {
    local array_name=$1
    declare -n service_pairs=$array_name
    local migration_found=false

    #echo "Checking for migration candidates of services..."

    for old_service in "${!service_pairs[@]}"; do
        new_service=${service_pairs[$old_service]}

        if [ -f "/etc/systemd/system/$old_service" ]; then
            migration_found=true
            if systemctl is-enabled --quiet "$old_service"; then
                systemctl disable "$old_service"
            fi

            if [ -n "$new_service" ]; then
                mv "/etc/systemd/system/$old_service" "/etc/systemd/system/$new_service"
                echo "Renamed $old_service to $new_service"
            else
                rm "/etc/systemd/system/$old_service"
                echo "Removed $old_service"
            fi
        fi
    done

    if [ "$migration_found" = true ]; then
        systemctl daemon-reload
        echo "Systemd daemon reloaded"
    else
        echo "No migration required for services."
    fi
}





# Dependencies
install_dependencies() {
echo -e "\n${YELLOW}Updating package list and installing dependencies...${NC}"
apt update
apt install -y curl lsb-release xfsprogs ntfs-3g smartmontools parted python3 python3-pip
pip3 install colorama
pip3 install requests
}

install_mergerfs() {
    echo -e "\n${YELLOW}Installing mergerfs...${NC}"
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

    echo -e "${GREEN}Installation or update completed.${NC}"
    echo
}

create_drectories() {
# Create /etc/chiagarden directory if it doesn't exist
echo -e "\n${YELLOW}Checking for /etc/chiagarden directory...${NC}"
if [[ ! -d /etc/chiagarden ]]; then
    echo -e "${YELLOW}Creating /etc/chiagarden directory...${NC}"
    mkdir /etc/chiagarden
    echo -e "${GREEN}/etc/chiagarden directory created.${NC}"
else
    echo -e "${GREEN}/etc/chiagarden${NC} directory already exists."
fi
}

copy_files() {
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
}

# Function to download madmax binaries
download_madmax() {
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
        echo -e "${GREEN}${file_name}${NC} already exists in /usr/local/bin/"
    fi
}

# Function to update systemd service files
update_service_file() {
    local service_dir="$1"
    local service_file="$2"
    local service_path="/etc/systemd/system/${service_file}"

    # Check for the existence of the service file in the system directory
    if [[ -e "${service_path}" ]]; then
        # Compare the existing service file with the new one
        if ! cmp -s "${service_dir}/${service_file}" "${service_path}"; then
            echo -e "${YELLOW}A modified ${service_file} exists.${NC}"
            # Ask the user what to do
            read -p "Do you want to backup the existing file and replace with the new one? [Y/n] " user_decision

            if [[ ! "$user_decision" =~ ^([nN][oO]|[nN])$ ]]; then
                # Backup the original file
                mv "${service_path}" "${service_path}.bak"
                echo -e "${GREEN}Backup created:${NC} ${service_path}/${service_file}.bak"

                # Copy the new service file
                cp "${service_dir}/${service_file}" "${service_path}"
                echo -e "${GREEN}${service_file}${NC} has been updated."
            else
                echo -e "${RED}Skipping update for${NC} ${service_file}."
            fi
        else
            echo -e "${GREEN}No changes detected in${NC} ${service_file}, ${GREEN}skipping update.${NC}"
        fi
        echo
    else
        # If the service file doesn't exist, simply copy it
        cp "${service_dir}/${service_file}" "${service_path}"
        echo -e "${GREEN}Installed new ${service_file}.${NC}"
    fi
}

# Function to get the current status of a service
get_service_status() {
  if systemctl is-enabled --quiet "$1"; then
    echo "ENABLED"
  else
    echo "DISABLED"
  fi
}

# Function to prompt for enabling/disabling a service
prompt_service_action() {
  local service=$1
  local description=$2
  local status=$(get_service_status "$service")
  echo -e "${YELLOW}Service: $service ($description)${NC}"
  read -p "Status: $status. Enable service? [Y/n] " enable_response
  if [[ ! "$enable_response" =~ ^([nN][oO]|[nN])$ ]]; then
    echo -e "${GREEN}Enabling $service...${NC}"
    systemctl enable "$service"
  elif [[ "$enable_response" =~ ^([nN][oO]|[nN])$ ]]; then
    echo -e "${GREEN}Disabling $service...${NC}"
    systemctl disable "$service"
  fi
  echo -e
}


clear
check_root
print_header
echo -e ${YELLOW}"Checking for migration candidates.."${NC}
migrate_files "files_to_migrate"
migrate_service_files "services_to_migrate"
install_dependencies

install_mergerfs
echo -e "${YELLOW}Downloading madMAx's binaries required for plot_starter https://github.com/madMAx43v3r...${NC}"
download_madmax "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/cuda-plotter/linux/x86_64/cuda_plot_k32" "cuda_plot_k32"
download_madmax "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/plot-sink/linux/x86_64/chia_plot_copy" "chia_plot_copy"
download_madmax "https://github.com/madMAx43v3r/chia-gigahorse/raw/master/plot-sink/linux/x86_64/chia_plot_sink" "chia_plot_sink"

create_drectories
copy_files

echo -e "\n${YELLOW}Updating systemd services...${NC}"
update_service_file "./gardenmount" "gardenmount.service"
update_service_file "./plotting" "plot_starter.service"
update_service_file "./plotting" "plotsink.service"
update_service_file "./plotting" "plot_over.service"
systemctl daemon-reload
echo -e

prompt_service_action "gardenmount.service" "Automount drives during boot"
prompt_service_action "plot_starter.service" "Start plotting upon boot"
prompt_service_action "plotsink.service" "Start MadMax's Plotsink on port 1337 during boot"
prompt_service_action "plot_over.service" "Start plot_over on boot"

echo -e "${BOLD}${GREEN}ChiaGarden installation complete!${NC}"
echo -e "Please read the README.md files for more information on how to use ChiaGarden.\n"
echo -e "${YELLOW}You may want to start by using chiainit to initialize your drives.${NC}\n"
echo

#!/bin/bash

# ChiaGarden Installer
# Usage: ./install.sh [--core|--uninstall|--help]

set -e

VERSION="2.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# Logging
LOGFILE=""

# Installation groups
CORE_TOOLS=(
    "chiainit"
    "gardenmount"
    "taco_list"
    "plot_counter"
    "cropgains"
)

PLOTTING_TOOLS=(
    "plot_starter"
    "plot_timer"
    "plot_cleaner"
    "plotsink"
    "plot_over"
    "plot_mover"
)

CORE_SERVICES=(
    "gardenmount.service"
)

PLOTTING_SERVICES=(
    "plot_starter.service"
    "plotsink.service"
    "plot_over.service"
)

# File migrations (old -> new, empty = delete)
declare -A FILES_TO_MIGRATE=(
    ["/usr/local/bin/plot_avg"]="/usr/local/bin/plot_timer"
)

# Service migrations (old -> new)
declare -A SERVICES_TO_MIGRATE=(
    ["plot-starter.service"]="plot_starter.service"
    ["garden-mount.service"]="gardenmount.service"
)

# ============================================================================
# HELPERS
# ============================================================================

usage() {
    echo "ChiaGarden Installer v${VERSION}"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --uninstall   Remove all ChiaGarden files"
    echo "  --log [FILE]  Write installation log (default: ./chiagarden-install-DATE.log)"
    echo "  --help        Show this help"
    echo
    echo "Run without options for interactive install."
    echo
    echo "Core tools:     ${CORE_TOOLS[*]}"
    echo "Plotting tools: ${PLOTTING_TOOLS[*]}"
    exit 0
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run as root${NC}"
        exit 1
    fi
}

confirm() {
    local prompt="$1"
    local default="${2:-Y}"
    local options="[Y/n]"
    [[ "$default" == "N" ]] && options="[y/N]"
    read -p "$prompt $options " -r response
    response=${response:-$default}
    [[ "$response" =~ ^[yY]([eE][sS])?$ ]]
}

# ============================================================================
# MIGRATIONS (for upgrades from older versions)
# ============================================================================

migrate_files() {
    local migrated=false
    for old_file in "${!FILES_TO_MIGRATE[@]}"; do
        new_file=${FILES_TO_MIGRATE[$old_file]}
        if [[ -f "$old_file" ]]; then
            migrated=true
            if [[ -n "$new_file" ]]; then
                mv "$old_file" "$new_file"
                echo -e "Renamed $old_file → $new_file"
            else
                rm "$old_file"
                echo -e "Removed $old_file"
            fi
        fi
    done
    $migrated || echo "No file migrations needed."
}

migrate_services() {
    local migrated=false
    for old_service in "${!SERVICES_TO_MIGRATE[@]}"; do
        new_service=${SERVICES_TO_MIGRATE[$old_service]}
        if [[ -f "/etc/systemd/system/$old_service" ]]; then
            migrated=true
            systemctl disable "$old_service" 2>/dev/null || true
            if [[ -n "$new_service" ]]; then
                mv "/etc/systemd/system/$old_service" "/etc/systemd/system/$new_service"
                echo -e "Renamed $old_service → $new_service"
            else
                rm "/etc/systemd/system/$old_service"
                echo -e "Removed $old_service"
            fi
        fi
    done
    $migrated && systemctl daemon-reload
    $migrated || echo "No service migrations needed."
}

# ============================================================================
# DEPENDENCIES
# ============================================================================

install_dependencies() {
    echo -e "\n${YELLOW}Installing dependencies...${NC}"
    apt-get update -qq
    apt-get install -y curl lsb-release xfsprogs ntfs-3g smartmontools parted bc python3 python3-pip duf

    # Handle pip differently for Ubuntu 24+ (PEP 668)
    if pip3 install --help 2>&1 | grep -q "break-system-packages"; then
        pip3 install --break-system-packages colorama requests
    else
        pip3 install colorama requests
    fi
}

install_mergerfs() {
    echo -e "\n${YELLOW}Installing mergerfs...${NC}"
    
    # Detect distro and codename
    local distro=""
    local codename=""
    
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            ubuntu)
                distro="ubuntu"
                codename="$VERSION_CODENAME"
                ;;
            debian)
                distro="debian"
                codename="$VERSION_CODENAME"
                ;;
            *)
                # Try parent distro (for derivatives like Linux Mint)
                if [[ "$ID_LIKE" == *"ubuntu"* ]]; then
                    distro="ubuntu"
                    codename="$UBUNTU_CODENAME"
                elif [[ "$ID_LIKE" == *"debian"* ]]; then
                    distro="debian"
                    codename="$VERSION_CODENAME"
                fi
                ;;
        esac
    fi
    
    # Fallback to lsb_release
    if [[ -z "$codename" ]]; then
        codename=$(lsb_release -cs 2>/dev/null || echo "")
    fi
    
    # Detect architecture
    local arch=""
    case "$(uname -m)" in
        x86_64)  arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l)  arch="armhf" ;;
        i686)    arch="i386" ;;
        riscv64) arch="riscv64" ;;
        *)       arch="" ;;
    esac
    
    # Get latest version from GitHub
    local version=""
    version=$(curl -fsSL "https://api.github.com/repos/trapexit/mergerfs/releases/latest" 2>/dev/null \
        | grep '"tag_name"' | cut -d'"' -f4)
    
    if [[ -z "$version" || -z "$distro" || -z "$codename" || -z "$arch" ]]; then
        echo -e "${YELLOW}Could not detect system or fetch version, falling back to apt...${NC}"
        apt-get install -y mergerfs
        return
    fi
    
    # Build URL: mergerfs_2.41.1.ubuntu-noble_amd64.deb
    local filename="mergerfs_${version}.${distro}-${codename}_${arch}.deb"
    local url="https://github.com/trapexit/mergerfs/releases/download/${version}/${filename}"
    
    echo "Detected: ${distro} ${codename} (${arch})"
    echo "Downloading mergerfs ${version}..."
    
    if curl -fsSL "$url" -o /tmp/mergerfs.deb && [[ -f /tmp/mergerfs.deb ]] && [[ $(stat -c%s /tmp/mergerfs.deb 2>/dev/null || echo 0) -gt 1000 ]]; then
        dpkg -i /tmp/mergerfs.deb
        rm /tmp/mergerfs.deb
        echo -e "${GREEN}mergerfs ${version} installed.${NC}"
    else
        echo -e "${YELLOW}Download failed for ${filename}${NC}"
        echo -e "${YELLOW}Falling back to apt...${NC}"
        rm -f /tmp/mergerfs.deb
        apt-get install -y mergerfs
    fi
}

# ============================================================================
# MADMAX BINARIES
# ============================================================================

download_madmax() {
    local file_url="$1"
    local file_name="$2"
    
    if [[ -e "/usr/local/bin/$file_name" ]]; then
        echo -e "${GREEN}$file_name${NC} already exists."
        return
    fi
    
    echo -e "Downloading $file_name..."
    if curl -fsSL "$file_url" -o "/usr/local/bin/$file_name"; then
        chmod +x "/usr/local/bin/$file_name"
        echo -e "${GREEN}$file_name installed.${NC}"
    else
        echo -e "${RED}Failed to download $file_name${NC}"
    fi
}

install_madmax_binaries() {
    echo -e "\n${YELLOW}Downloading MadMax binaries...${NC}"
    local base="https://github.com/madMAx43v3r/chia-gigahorse/raw/master"
    
    download_madmax "${base}/cuda-plotter/linux/x86_64/cuda_plot_k32" "cuda_plot_k32"
    download_madmax "${base}/plot-sink/linux/x86_64/chia_plot_copy" "chia_plot_copy"
    download_madmax "${base}/plot-sink/linux/x86_64/chia_plot_sink" "chia_plot_sink"
}

# ============================================================================
# TOOL INSTALLATION
# ============================================================================

copy_tool() {
    local tool="$1"
    local src="./${tool}/${tool}"
    
    if [[ -e "$src" ]]; then
        cp "$src" /usr/local/bin/
        echo -e "${GREEN}Installed${NC} $tool"
    else
        echo -e "${RED}Error: $src not found${NC}"
        exit 1
    fi
}

install_service() {
    local tool="$1"
    local service="${tool}.service"
    local src="./${tool}/${service}"
    local dest="/etc/systemd/system/${service}"
    
    [[ ! -f "$src" ]] && return
    
    if [[ -f "$dest" ]] && ! cmp -s "$src" "$dest"; then
        echo -e "${YELLOW}Service $service has local changes.${NC}"
        if confirm "Backup and replace?"; then
            mv "$dest" "${dest}.bak"
            cp "$src" "$dest"
            echo -e "Backed up and updated $service"
        else
            echo -e "Skipped $service"
        fi
    else
        cp "$src" "$dest"
        echo -e "${GREEN}Installed${NC} $service"
    fi
}

prompt_enable_service() {
    local service="$1"
    local description="$2"
    
    [[ ! -f "/etc/systemd/system/$service" ]] && return
    
    local state="OFF"
    systemctl is-enabled --quiet "$service" 2>/dev/null && state="ON"
    local original_state="$state"
    
    # Format service name (remove .service suffix for cleaner look)
    local name="${service%.service}"
    
    while true; do
        # Build status indicator
        local indicator
        if [[ "$state" == "ON" ]]; then
            indicator="${GREEN}●${NC} ON "
        else
            indicator="${RED}○${NC} OFF"
        fi
        
        echo -ne "\r\033[K  ${indicator}  ${BOLD}${name}${NC} – ${description}  [space/enter]"
        
        IFS= read -rsn1 key
        
        if [[ -z "$key" ]]; then  # Enter
            echo -ne "\r\033[K"  # Clear line before final output
            break
        elif [[ "$key" == " " ]]; then  # Space
            if [[ "$state" == "ON" ]]; then
                state="OFF"
            else
                state="ON"
            fi
        fi
    done
    
    # Final display
    local indicator
    local changed=""
    if [[ "$state" == "ON" ]]; then
        indicator="${GREEN}●${NC} ON "
    else
        indicator="${RED}○${NC} OFF"
    fi
    
    if [[ "$state" != "$original_state" ]]; then
        if [[ "$state" == "ON" ]]; then
            systemctl enable "$service" >/dev/null 2>&1
        else
            systemctl disable "$service" >/dev/null 2>&1
        fi
        changed=" ${GREEN}✓${NC}"
    fi
    
    echo -e "  ${indicator}  ${BOLD}${name}${NC} – ${description}${changed}"
}

configure_services() {
    local include_plotting="${1:-true}"
    
    echo -e "  ${YELLOW}space${NC}=toggle  ${YELLOW}enter${NC}=next\n"
    
    prompt_enable_service "gardenmount.service" "Mount drives on boot"
    
    if [[ "$include_plotting" == "true" ]]; then
        prompt_enable_service "plot_starter.service" "Start plotter on boot"
        prompt_enable_service "plotsink.service" "Receive plots over network"
        prompt_enable_service "plot_over.service" "Keep drives free for replotting"
    fi
}

# ============================================================================
# INSTALL
# ============================================================================

do_install() {
    clear
    echo -e "${GREEN}${BOLD}"
    cat << 'EOF'
   ____ _     _        ____               _            
  / ___| |__ (_) __ _ / ___| __ _ _ __ __| | ___ _ __  
 | |   | '_ \| |/ _` | |  _ / _` | '__/ _` |/ _ \ '_ \ 
 | |___| | | | | (_| | |_| | (_| | | | (_| |  __/ | | |
  \____|_| |_|_|\__,_|\____|\__,_|_|  \__,_|\___|_| |_|
EOF
    echo -e "${NC}"
    echo -e "  ${BOLD}v${VERSION}${NC} - Linux toolkit for large-scale Chia farming"
    echo
    
    echo "What would you like to do?"
    echo
    echo -e "  ${BOLD}1)${NC} Core only"
    echo "     Drive management and monitoring (no plotting)"
    echo
    echo -e "  ${BOLD}2)${NC} Core + Plotting tools"
    echo "     Everything you need to run and plot a Chia farm"
    echo
    echo -e "  ${BOLD}3)${NC} Configure services only"
    echo "     Enable/disable systemd services"
    echo
    echo -e "  ${BOLD}4)${NC} Uninstall"
    echo "     Remove ChiaGarden tools and services"
    echo
    
    local choice
    read -p "Choose [1]: " choice
    choice=${choice:-1}
    
    local install_plotting="true"
    local services_only="false"
    case "$choice" in
        1) install_plotting="false" ;;
        2) install_plotting="true" ;;
        3) services_only="true" ;;
        4) do_uninstall; exit 0 ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            exit 1
            ;;
    esac
    
    # Services only mode
    if [[ "$services_only" == "true" ]]; then
        echo -e "\n${YELLOW}Configure services...${NC}\n"
        configure_services true
        echo -e "\n${GREEN}Done.${NC}\n"
        exit 0
    fi
    
    # Show what will be installed
    echo
    echo -e "${YELLOW}The following will be installed:${NC}"
    echo
    echo -e "${BOLD}APT packages:${NC}"
    echo "  curl, lsb-release, xfsprogs, ntfs-3g, smartmontools, parted, bc,"
    echo "  python3, python3-pip, duf, mergerfs"
    echo
    echo -e "${BOLD}Python packages:${NC}"
    echo "  colorama, requests"
    echo
    echo -e "${BOLD}ChiaGarden tools:${NC}"
    echo -n "  "
    local tools=("${CORE_TOOLS[@]}")
    if [[ "$install_plotting" == "true" ]]; then
        tools+=("${PLOTTING_TOOLS[@]}")
    fi
    local first=true
    for tool in "${tools[@]}"; do
        if $first; then
            echo -n "$tool"
            first=false
        else
            echo -n ", $tool"
        fi
    done
    echo
    
    if [[ "$install_plotting" == "true" ]]; then
        echo
        echo -e "${BOLD}MadMax binaries:${NC}"
        echo "  cuda_plot_k32, chia_plot_copy, chia_plot_sink"
    fi
    
    echo
    if ! confirm "Do you want to continue?"; then
        echo -e "${YELLOW}Cancelled.${NC}"
        exit 0
    fi
    
    # Migrations
    echo -e "\n${YELLOW}Checking for migrations...${NC}"
    migrate_files
    migrate_services
    
    # Dependencies
    install_dependencies
    install_mergerfs
    
    # MadMax binaries (only if plotting)
    [[ "$install_plotting" == "true" ]] && install_madmax_binaries
    
    # Config directory
    echo -e "\n${YELLOW}Creating directories...${NC}"
    mkdir -p /etc/chiagarden
    echo -e "${GREEN}/etc/chiagarden${NC} ready."
    
    # Copy tools
    echo -e "\n${YELLOW}Installing tools...${NC}"
    for tool in "${CORE_TOOLS[@]}"; do
        copy_tool "$tool"
    done
    
    if [[ "$install_plotting" == "true" ]]; then
        for tool in "${PLOTTING_TOOLS[@]}"; do
            copy_tool "$tool"
        done
    fi
    
    # Install services
    echo -e "\n${YELLOW}Installing services...${NC}"
    for tool in "${CORE_TOOLS[@]}"; do
        install_service "$tool"
    done
    
    if [[ "$install_plotting" == "true" ]]; then
        for tool in "${PLOTTING_TOOLS[@]}"; do
            install_service "$tool"
        done
    fi
    
    systemctl daemon-reload
    
    # Enable services
    echo -e "\n${YELLOW}Configure services...${NC}\n"
    configure_services "$install_plotting"
    
    # Done
    echo -e "\n${BOLD}${GREEN}ChiaGarden v${VERSION} installed!${NC}\n"
    echo -e "Get started:"
    echo -e "  ${YELLOW}chiainit --list${NC}      Show your drives"
    echo -e "  ${YELLOW}gardenmount --list${NC}   Show mount status"
    echo
    echo -e "Each tool has a README in its directory for details."
    echo
}

# ============================================================================
# UNINSTALL
# ============================================================================

do_uninstall() {
    echo -e "\n${RED}${BOLD}ChiaGarden Uninstaller${NC}\n"
    echo "This will remove all ChiaGarden tools and services."
    echo -e "${YELLOW}MadMax binaries and /etc/chiagarden configs will be kept.${NC}"
    echo
    
    if ! confirm "Proceed?" "N"; then
        echo -e "${YELLOW}Cancelled.${NC}"
        exit 0
    fi
    
    # Stop and disable services
    echo -e "\n${YELLOW}Stopping services...${NC}"
    for service in "${CORE_SERVICES[@]}" "${PLOTTING_SERVICES[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            systemctl stop "$service"
            echo "Stopped $service"
        fi
        if systemctl is-enabled --quiet "$service" 2>/dev/null; then
            systemctl disable "$service"
            echo "Disabled $service"
        fi
        if [[ -f "/etc/systemd/system/$service" ]]; then
            rm "/etc/systemd/system/$service"
            echo "Removed $service"
        fi
    done
    systemctl daemon-reload
    
    # Remove tools
    echo -e "\n${YELLOW}Removing tools...${NC}"
    for tool in "${CORE_TOOLS[@]}" "${PLOTTING_TOOLS[@]}"; do
        if [[ -f "/usr/local/bin/$tool" ]]; then
            rm "/usr/local/bin/$tool"
            echo "Removed $tool"
        fi
    done
    
    echo -e "\n${GREEN}ChiaGarden uninstalled.${NC}"
    echo -e "Kept: /etc/chiagarden/, MadMax binaries (cuda_plot_k32, chia_plot_sink, chia_plot_copy)"
    echo
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    local action="install"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                usage
                ;;
            --uninstall)
                action="uninstall"
                shift
                ;;
            --log)
                if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then
                    LOGFILE="$2"
                    shift 2
                else
                    LOGFILE="./chiagarden-install-$(date +%Y%m%d-%H%M%S).log"
                    shift
                fi
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                usage
                ;;
        esac
    done
    
    # Set up logging if requested
    if [[ -n "$LOGFILE" ]]; then
        echo "Logging to $LOGFILE"
        exec > >(tee -a "$LOGFILE") 2>&1
        echo "=== ChiaGarden Install Log $(date) ==="
    fi
    
    # Execute action
    check_root
    case "$action" in
        uninstall)
            do_uninstall
            ;;
        *)
            do_install
            ;;
    esac
}

main "$@"

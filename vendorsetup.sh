#!/usr/bin/env bash

# ANSI Color and Formatting Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
RESET='\033[0m'

# Spinner Animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [${CYAN}%c${RESET}] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Logging Functions
log_start() {
    printf "${BOLD}${BLUE}➜${RESET} ${WHITE}%s${RESET}\n" "$1"
}

log_success() {
    printf "${BOLD}${GREEN}✔${RESET} ${WHITE}%s${RESET}\n" "$1"
}

log_warning() {
    printf "${BOLD}${YELLOW}⚠${RESET} ${WHITE}%s${RESET}\n" "$1"
}

log_error() {
    printf "${BOLD}${RED}✘${RESET} ${WHITE}%s${RESET}\n" "$1"
}

log_info() {
    printf "${BOLD}${CYAN}ℹ${RESET} ${WHITE}%s${RESET}\n" "$1"
}

# Progress Bar Function
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    
    printf "\r${BOLD}${BLUE}Progress:${RESET} ["
    printf "${GREEN}%*s${RESET}" "$completed" | tr ' ' '='
    printf "%*s" $((width - completed)) | tr ' ' ' '
    printf "] ${YELLOW}%3d%%${RESET}" "$percentage"
}

# Advanced Check Directory Function
check_and_clone() {
    local dir_path=$1
    local repo_url=$2
    local branch=$3
    local description=$4

    log_start "Checking ${description} sources..."
    
    if [ -d "$dir_path" ]; then
        log_warning "• ${dir_path} already exists. Skipping cloning..."
        return 1
    fi

    log_info "Cloning ${description} from ${repo_url} (branch: ${branch})"
    
    # Simulating clone with progress
    (
        git clone --progress "$repo_url" -b "$branch" "$dir_path" 2>&1 |
        while read -r line; do
            if [[ "$line" =~ Receiving\ objects:\ *([0-9]+)%\ \(([0-9]+)/([0-9]+)\) ]]; then
                progress_bar "${BASH_REMATCH[1]}" 100
            fi
        done
    ) & spinner $!

    if [ $? -eq 0 ]; then
        log_success "Successfully cloned ${description}"
        return 0
    else
        log_error "Failed to clone ${description}"
        return 1
    fi
}

# Main Execution
main() {
    clear
    printf "${BOLD}${MAGENTA}
 ╔═══════════════════════════════════════╗
 ║   Android ROM Source Preparation     ║
 ╚═══════════════════════════════════════╝
${RESET}\n"

    # Configuration Variables
    VENDOR_BRANCH="15.0"
    KERNEL_BRANCH="vauxite"
    HARDWARE_BRANCH="15"
    DEBUG_BRANCH="lineage-22"

    # Cleanup Steps
    log_start "Preparing device sources..."
    
    log_info "Removing conflicting headers and modules"
    rm -rf hardware/google/pixel/kernel_headers/Android.bp
    rm -rf hardware/lineage/compat/Android.bp

    # Cloning Sources
    check_and_clone "vendor/xiaomi/spes" \
        "git@github.com:justkelvin/vendor_xiaomi_spes.git" \
        "$VENDOR_BRANCH" "Vendor"

    check_and_clone "kernel/xiaomi/sm6225" \
        "git@github.com:justkelvin/kernel_xiaomi_sm6225.git" \
        "$KERNEL_BRANCH" "Kernel"

    check_and_clone "hardware/xiaomi" \
        "https://github.com/ProjectPixelage/android_hardware_xiaomi.git" \
        "$HARDWARE_BRANCH" "Hardware"

    check_and_clone "hardware/samsung-ext/interfaces" \
        "https://github.com/spes-development/hardware_samsung-extra_interfaces" \
        "$DEBUG_BRANCH" "Debugging Tools"

    # Final Status
    printf "\n${BOLD}${GREEN}
 ╔═══════════════════════════════════════╗
 ║   Device Sources Preparation Done!    ║
 ╚═══════════════════════════════════════╝
${RESET}\n"
}

# Run the main function
main

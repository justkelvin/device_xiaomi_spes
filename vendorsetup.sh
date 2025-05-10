#!/usr/bin/env bash

clear
printf "${BOLD}${MAGENTA}
 ╔═══════════════════════════════════════╗
 ║   Android ROM Source Preparation      ║
 ╚═══════════════════════════════════════╝
${RESET}\n"

# Configuration Variables
# VENDOR_BRANCH="15.0"
# KERNEL_BRANCH="vauxite"
# HARDWARE_BRANCH="15"
# DEBUG_BRANCH="lineage-22"
# MIUI_CAMERA_BRANCH="leica-5.0"

    
printf "Removing conflicting headers and modules"
rm -rf hardware/google/pixel/kernel_headers/Android.bp


# Final Status
printf "\n${BOLD}${GREEN}
 ╔═══════════════════════════════════════╗
 ║   Device Sources Preparation Done!    ║
 ╚═══════════════════════════════════════╝
${RESET}\n"
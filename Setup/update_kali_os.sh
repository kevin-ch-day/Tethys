#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display messages with enhanced formatting
echo_step() {
  echo -e "\n\e[1;34m==============================================\e[0m"
  echo -e "\e[1;32m$1\e[0m"
  echo -e "\e[1;34m==============================================\e[0m\n"
}

# Display header
echo -e "\e[1;36m################################################################################\e[0m"
echo -e "\e[1;33m           KALI LINUX UPDATE AND UPGRADE SCRIPT\e[0m"
echo -e "\e[1;36m################################################################################\e[0m\n"

# Update and upgrade the system
echo_step "Updating package lists and upgrading installed packages..."
apt update && apt -y upgrade

# Final message
echo -e "\e[1;36m################################################################################\e[0m"
echo -e "\e[1;32m  Update and Upgrade Complete: Your Kali Linux is Up to Date!\e[0m"
echo -e "\e[1;36m################################################################################\e[0m"

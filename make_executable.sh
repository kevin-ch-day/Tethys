#!/bin/bash

################################################################################
#              Script to Make All Shell Scripts Executable                   #
################################################################################

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display messages with enhanced formatting
echo_step() {
  echo -e "\n\e[1;100m\e[1;97m==============================================\e[0m"
  echo -e "\e[1;104m\e[1;97m$1\e[0m"
  echo -e "\e[1;100m\e[1;97m==============================================\e[0m\n"
}

# Display header
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;104m           MAKE SHELL SCRIPTS EXECUTABLE SCRIPT\e[0m"
echo -e "\e[1;100m################################################################################\e[0m\n"

# Step 1: Find and change permissions of .sh files
echo_step "Step 1: Searching for .sh files..."
sh_files=$(find . -maxdepth 1 -type f -name "*.sh")

if [ -z "$sh_files" ]; then
  echo -e "\e[1;101mNo .sh files found in the current directory!\e[0m"
else
  echo -e "\e[1;96mFound the following .sh files:\e[0m"
  echo "$sh_files"

  echo_step "Step 2: Making .sh files executable..."
  chmod +x *.sh
  echo -e "\e[1;92mAll .sh files have been made executable!\e[0m"
fi

# Final message
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;102m  Script Complete: All .sh Files are Now Executable!\e[0m"
echo -e "\e[1;100m################################################################################\e[0m"

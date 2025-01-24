#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Hard-coded Git configuration (leave empty to prompt user)
HARD_CODED_USERNAME="kevin-ch-day"
HARD_CODED_EMAIL="kevinday612-softwaredev@outlook.com"

# Function to install Git
install_git() {
  echo "========================================="
  echo "          Installing Git                "
  echo "========================================="

  echo "Updating package list and installing Git..."
  apt update && apt install -y git
  if [ $? -ne 0 ]; then
    echo "Failed to install Git. Exiting."
    exit 1
  fi
  echo "Git installed successfully."
}

# Function to verify global Git configuration
verify_global_git_config() {
  echo "========================================="
  echo "     Verifying Global Git Configuration  "
  echo "========================================="

  # Check for global username
  git_username=$(git config --global user.name 2>/dev/null)
  if [ -n "$git_username" ]; then
    echo "Global Git Username: $git_username"
  else
    echo "Global Git Username is not set."
  fi

  # Check for global email
  git_email=$(git config --global user.email 2>/dev/null)
  if [ -n "$git_email" ]; then
    echo "Global Git Email: $git_email"
  else
    echo "Global Git Email is not set."
  fi
}

# Function to prompt user to set global Git configuration if not set
set_global_git_config() {
  echo "========================================="
  echo "       Configuring Git Settings          "
  echo "========================================="

  if [ -z "$HARD_CODED_USERNAME" ] || [ -z "$HARD_CODED_EMAIL" ]; then
    echo "Interactive mode: Configuring Git..."

    if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
      read -p "Enter a global Git username: " new_username
      git config --global user.name "$new_username"
      echo "Global Git Username set to: $new_username"
    fi

    if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
      read -p "Enter a global Git email: " new_email
      git config --global user.email "$new_email"
      echo "Global Git Email set to: $new_email"
    fi
  else
    echo "Using hard-coded Git configuration..."
    git config --global user.name "$HARD_CODED_USERNAME"
    git config --global user.email "$HARD_CODED_EMAIL"
    echo "Global Git Username set to: $HARD_CODED_USERNAME"
    echo "Global Git Email set to: $HARD_CODED_EMAIL"
  fi
}

# Main script execution
install_git
verify_global_git_config
set_global_git_config
verify_global_git_config
#!/bin/bash

# Function to verify global Git configuration
verify_global_git_config() {
  echo "============================="
  echo " Verifying Global Git Configuration"
  echo "============================="

  # Check for global username
  git_username=$(git config --global user.name 2>/dev/null)
  if [ -n "$git_username" ]; then
    echo "Global Git username: $git_username"
  else
    echo "Global Git username is not set."
  fi

  # Check for global email
  git_email=$(git config --global user.email 2>/dev/null)
  if [ -n "$git_email" ]; then
    echo "Global Git email: $git_email"
  else
    echo "Global Git email is not set."
  fi

  echo "============================="
}

# Function to prompt user to set global Git configuration if not set
set_global_git_config() {
  if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
    read -p "Enter a global Git username: " new_username
    git config --global user.name "$new_username"
    echo "Global Git username set to: $new_username"
  fi

  if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
    read -p "Enter a global Git email: " new_email
    git config --global user.email "$new_email"
    echo "Global Git email set to: $new_email"
  fi
}

# Main execution
verify_global_git_config
set_global_git_config
verify_global_git_config

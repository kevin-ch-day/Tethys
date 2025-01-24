#!/bin/bash

################################################################################
#                     Enhanced Disk Usage Checker Script                      #
#   This script provides detailed disk usage statistics, including storage    #
#   utilization, largest files/directories, and inode usage, with extra       #
#   insights for system monitoring.                                           #
################################################################################

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display messages with enhanced formatting
echo_step() {
  echo -e "\n\e[1;44m\e[1;97m==============================================\e[0m"
  echo -e "\e[1;42m\e[1;97m$1\e[0m"
  echo -e "\e[1;44m\e[1;97m==============================================\e[0m\n"
}

# Function to display a processing message during long tasks
show_processing_message() {
  local message="$1"
  while :; do
    echo -ne "\e[1;96m$message\e[0m\r"
    sleep 1
  done
}

# Display header
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;104m               ENHANCED DISK USAGE CHECKER SCRIPT\e[0m"
echo -e "\e[1;100m################################################################################\e[0m\n"

# Step 1: Display overall disk usage
echo_step "Step 1: Overall Disk Usage"
df -h | column -t || echo -e "\e[1;91mFailed to fetch disk usage information.\e[0m"

# Step 2: Display disk usage per mount point
echo_step "Step 2: Disk Usage by Mount Point"
df -hT | column -t || echo -e "\e[1;91mFailed to fetch disk usage by mount point.\e[0m"

# Step 3: Identify largest directories in root partition
echo_step "Step 3: Largest Directories in Root Partition"
echo -e "\e[1;96mAnalyzing... this may take a few moments\e[0m"
show_processing_message "Analyzing directories..." &
processing_pid=$!
du -ah / --max-depth=1 2>/dev/null | sort -rh | head -n 10 | column -t || echo -e "\e[1;91mFailed to identify largest directories.\e[0m"
kill $processing_pid

# Step 4: Identify largest files in root partition
echo_step "Step 4: Largest Files in Root Partition"
echo -e "\e[1;96mAnalyzing... this may take a few moments\e[0m"
show_processing_message "Analyzing files..." &
processing_pid=$!
find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 4 | column -t || echo -e "\e[1;91mFailed to identify largest files.\e[0m"
kill $processing_pid

# Step 5: Display inode usage
echo_step "Step 5: Inodes Usage"
df -i | column -t || echo -e "\e[1;91mFailed to fetch inodes usage information.\e[0m"

# Step 6: Check disk I/O stats
echo_step "Step 6: Disk I/O Statistics"
echo -e "\e[1;96mFetching disk I/O statistics...\e[0m"
iostat -dx 1 3 | column -t || echo -e "\e[1;91mFailed to fetch disk I/O statistics. Please install sysstat package if not available.\e[0m"

# Step 7: Display filesystem types and mount options
echo_step "Step 7: Filesystem Types and Mount Options"
lsblk -o NAME,FSTYPE,FSVER,LABEL,UUID,FSAVAIL,FSUSE%,MOUNTPOINTS | column -t || echo -e "\e[1;91mFailed to fetch filesystem information.\e[0m"

# Step 8: Show disk partitions and their sizes
echo_step "Step 8: Disk Partitions and Sizes"
fdisk -l 2>/dev/null | grep -E '^Disk /' | column -t || echo -e "\e[1;91mFailed to fetch disk partition information.\e[0m"

# Step 9: Analyze free space and usage patterns
echo_step "Step 9: Analyzing Free Space and Usage Patterns"
echo -e "\e[1;96mGenerating insights...\e[0m"
fs_usage=$(df -h | awk 'NR>1 {printf "%-20s %-10s\n", $1, $5}' | sort -k2 -r)
echo -e "\e[1;92mFilesystem Usage:\n$fs_usage\e[0m"

# Step 10: Recommendations based on disk usage
echo_step "Step 10: Recommendations Based on Disk Usage"
df -h | awk 'NR>1 {if ($5+0 > 80) printf "\033[1;91mWarning: High usage on %-20s (%s used)\033[0m\n", $1, $5; else printf "\033[1;92mHealthy: %-20s (%s used)\033[0m\n", $1, $5}'

# Summary
summary() {
  echo -e "\n\e[1;44mSUMMARY:\e[0m"
  echo -e "\e[1;92mLargest Directory:\e[0m $(du -ah / --max-depth=1 2>/dev/null | sort -rh | head -n 1 | awk '{print $2}')"
  echo -e "\e[1;92mLargest Files (Top 4):\e[0m"
  find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 4 | awk '{print "  "$2 " (" $1 ")"}'
  echo -e "\e[1;92mFilesystem with Most Space Used:\e[0m $(df -h | sort -k5 -r | head -n 2 | tail -n 1 | awk '{print $1, $5}')"
}
summary

# Final message
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;102m  Disk Usage Check Complete: Comprehensive Insights Provided!  \e[0m"
echo -e "\e[1;100m################################################################################\e[0m"

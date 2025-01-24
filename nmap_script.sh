#!/bin/bash

################################################################################
#                       Basic Nmap Script for CCDC                            #
#   This script automates common Nmap scans to assist during the CCDC event.  #
################################################################################

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display messages with enhanced formatting
echo_step() {
  echo -e "\n\e[1;44m\e[1;97m==============================================\e[0m"
  echo -e "\e[1;42m\e[1;97m$1\e[0m"
  echo -e "\e[1;44m\e[1;97m==============================================\e[0m\n"
}

# Check if the target IP or range is provided
if [ -z "$1" ]; then
  echo -e "\e[1;91mUsage: $0 <target_ip_or_range>\e[0m"
  exit 1
fi

TARGET="$1"
OUTPUT_DIR="nmap_results"
mkdir -p "$OUTPUT_DIR"

# Step 1: Ping Sweep
echo_step "Step 1: Performing Ping Sweep"
nmap -sn "$TARGET" -oN "$OUTPUT_DIR/ping_sweep.txt"
echo -e "\e[1;92mPing Sweep Results Saved to $OUTPUT_DIR/ping_sweep.txt\e[0m"

# Step 2: Quick Scan
echo_step "Step 2: Performing Quick Scan"
nmap -T4 -F "$TARGET" -oN "$OUTPUT_DIR/quick_scan.txt"
echo -e "\e[1;92mQuick Scan Results Saved to $OUTPUT_DIR/quick_scan.txt\e[0m"

# Step 3: Detailed Port Scan
echo_step "Step 3: Performing Detailed Port Scan"
nmap -p- -T4 "$TARGET" -oN "$OUTPUT_DIR/detailed_port_scan.txt"
echo -e "\e[1;92mDetailed Port Scan Results Saved to $OUTPUT_DIR/detailed_port_scan.txt\e[0m"

# Step 4: Service Version and OS Detection
echo_step "Step 4: Performing Service and OS Detection"
nmap -sV -sC -O "$TARGET" -oN "$OUTPUT_DIR/service_os_detection.txt"
echo -e "\e[1;92mService and OS Detection Results Saved to $OUTPUT_DIR/service_os_detection.txt\e[0m"

# Step 5: Vulnerability Scan (using default scripts)
echo_step "Step 5: Performing Vulnerability Scan"
nmap --script vuln "$TARGET" -oN "$OUTPUT_DIR/vulnerability_scan.txt"
echo -e "\e[1;92mVulnerability Scan Results Saved to $OUTPUT_DIR/vulnerability_scan.txt\e[0m"

# Final Message
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;102m  Nmap Scans Complete: Results Saved to $OUTPUT_DIR  \e[0m"
echo -e "\e[1;100m################################################################################\e[0m"

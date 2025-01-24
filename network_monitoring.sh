#!/bin/bash

################################################################################
#       Kali Linux Network Monitoring and Health Check Script                #
#   This script monitors network connections, open ports, and firewall rules. #
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
echo -e "\e[1;104m        KALI LINUX NETWORK MONITORING AND HEALTH CHECK SCRIPT\e[0m"
echo -e "\e[1;100m################################################################################\e[0m\n"

# Step 1: Check active network interfaces
echo_step "Step 1: Checking Active Network Interfaces..."
interfaces=$(ip -br a | grep UP | awk '{print $1}')
if [ -n "$interfaces" ]; then
  echo -e "\e[1;96mActive Network Interfaces:\e[0m\n$interfaces"
else
  echo -e "\e[1;101mNo active network interfaces found!\e[0m"
fi

# Step 2: Scan open ports
echo_step "Step 2: Scanning Open Ports..."
open_ports=$(netstat -tuln | grep LISTEN | awk '{printf "%-10s %-20s\n", $1, $4}')
if [ -n "$open_ports" ]; then
  echo -e "\e[1;96mOpen Ports:\e[0m\n$open_ports"
else
  echo -e "\e[1;101mNo open ports detected!\e[0m"
fi

# Step 3: Display firewall rules
echo_step "Step 3: Displaying Firewall Rules..."
if command -v ufw &> /dev/null; then
  ufw_status=$(ufw status verbose)
  echo -e "\e[1;96mUFW Firewall Rules:\e[0m\n$ufw_status"
elif command -v iptables &> /dev/null; then
  iptables_rules=$(iptables -L -n -v)
  echo -e "\e[1;96mIPTables Rules:\e[0m\n$iptables_rules"
else
  echo -e "\e[1;101mNo firewall tool detected (UFW/IPTables)!\e[0m"
fi

# Step 4: Check system resource usage
echo_step "Step 4: Checking System Resource Usage..."
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}')
memory_usage=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
disk_usage=$(df -h / | awk '/\// {print $3 "/" $2}')

echo -e "\e[1;96mCPU Usage:\e[0m $cpu_usage"
echo -e "\e[1;96mMemory Usage:\e[0m $memory_usage"
echo -e "\e[1;96mDisk Usage:\e[0m $disk_usage"

# Final message
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;102m  Network Monitoring Complete: Stay Secure and Informed!\e[0m"
echo -e "\e[1;100m################################################################################\e[0m"

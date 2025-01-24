#!/bin/bash

################################################################################
#             Comprehensive Red Team Environment Setup for Kali Linux          #
################################################################################

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
echo -e "\e[1;33m        KALI LINUX RED TEAM ENVIRONMENT SETUP SCRIPT\e[0m"
echo -e "\e[1;36m################################################################################\e[0m\n"

# Update and upgrade the system
echo_step "Step 1: Updating and Upgrading the System..."
apt update && apt -y upgrade

# Install VSCode
echo_step "Step 2: Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code
rm -f packages.microsoft.gpg

# Install Google Chrome
echo_step "Step 3: Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Install Cinnamon Desktop
echo_step "Step 4: Installing Cinnamon Desktop Environment..."
apt-get install -y kali-defaults kali-root-login desktop-base cinnamon

# Install Nmap and essential tools for Red Teaming
echo_step "Step 5: Installing Nmap and Essential Tools..."
apt install -y nmap net-tools curl wget tmux

# Install Metasploit Framework
echo_step "Step 6: Installing Metasploit Framework..."
apt install -y metasploit-framework

# Install BloodHound and Neo4j
echo_step "Step 7: Installing BloodHound and Neo4j..."
apt install -y bloodhound neo4j

# Install Impacket
echo_step "Step 8: Installing Impacket..."
apt install -y python3-impacket

# Install CrackMapExec
echo_step "Step 9: Installing CrackMapExec..."
apt install -y crackmapexec

# Install Wireshark
echo_step "Step 10: Installing Wireshark..."
apt install -y wireshark

# Install Additional Wordlists
echo_step "Step 11: Installing SecLists and RockYou Wordlists..."
apt install -y seclists
gzip -d /usr/share/wordlists/rockyou.txt.gz

# Configure Neo4j for BloodHound
echo_step "Step 12: Configuring Neo4j for BloodHound..."
systemctl enable neo4j.service
systemctl start neo4j.service

# Final summary and completion message
echo -e "\e[1;36m################################################################################\e[0m"
echo -e "\e[1;32m  Setup Complete: Your Kali Linux is Now Fully Configured for Red Teaming!\e[0m"
echo -e "\e[1;36m################################################################################\e[0m"

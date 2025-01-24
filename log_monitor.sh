#!/bin/bash

################################################################################
#             Enhanced Real-Time Log Monitoring and Alert Script             #
#   This script monitors critical logs and improves feedback for missing     #
#   or unavailable log files, ensuring a better user experience.             #
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
echo -e "\e[1;104m           ENHANCED REAL-TIME LOG MONITORING SCRIPT\e[0m"
echo -e "\e[1;100m################################################################################\e[0m\n"

# Logs to monitor
LOG_FILES=()

# Detect available log files dynamically
if [ -f "/var/log/syslog" ]; then
  LOG_FILES+=("/var/log/syslog")
else
  echo -e "\e[1;93m[WARNING]\e[0m Log file not found: /var/log/syslog"
fi

if [ -f "/var/log/auth.log" ]; then
  LOG_FILES+=("/var/log/auth.log")
else
  echo -e "\e[1;93m[WARNING]\e[0m Log file not found: /var/log/auth.log"
fi

if [ -f "/var/log/kern.log" ]; then
  LOG_FILES+=("/var/log/kern.log")
else
  echo -e "\e[1;93m[WARNING]\e[0m Log file not found: /var/log/kern.log"
fi

# If no log files are found, exit gracefully
if [ ${#LOG_FILES[@]} -eq 0 ]; then
  echo -e "\e[1;101m[ERROR]\e[0m No valid log files found! Exiting."
  exit 1
fi

# Display the log files being monitored
echo_step "Step 1: Monitoring the Following Log Files..."
for log_file in "${LOG_FILES[@]}"; do
  echo -e "\e[1;92m[OK]\e[0m Monitoring: $log_file"
done

# Monitor logs in real-time
echo_step "Step 2: Monitoring Logs in Real-Time..."
echo -e "\e[1;96mPress Ctrl+C to stop monitoring.\e[0m\n"

# Use tail to monitor all valid log files
tail -F "${LOG_FILES[@]}" | awk '
/(failed|error|critical|denied|unauthorized)/ {
  printf "\033[1;91m[ALERT]\033[0m %s\n", $0
}
/(success|accepted)/ {
  printf "\033[1;92m[INFO]\033[0m %s\n", $0
}'

# Final message
echo -e "\e[1;100m################################################################################\e[0m"
echo -e "\e[1;102m  Monitoring Stopped: Review Logs for Additional Details  \e[0m"
echo -e "\e[1;100m################################################################################\e[0m"

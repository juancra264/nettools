#!/bin/bash
# #############################################################################
## Set Colors for echo messages
# #############################################################################
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

# #############################################################################
## Global Variables
# #############################################################################
backup_date=$(date +"%Y%m%d_%H%M%S")
# Get the real path of the current script
SCRIPT_REAL_PATH=$(realpath "$0")
# To get just the directory of the script
SCRIPT_PATH=$(dirname "$SCRIPT_REAL_PATH")
# Source the config file to load variables
source $SCRIPT_PATH/config.sh

# #############################################################################
# ## Functions Declarations
# #############################################################################
send_discord_msg() {
  # Define a function to send a message
  local message=$1

  # Construct payload
  local payload=$(cat <<EOF
{
  "content": "$message"
}
EOF
  )
  # Send POST request to Discord Webhook
  curl -H "Content-Type: application/json" -X POST -d "$payload" $discord_url
}

speedtest(){
  # File to store results
  RESULTS_FILE="speedtest_results.txt"
  # get hostname
  host=hostname
  # Run Speedtest and save output to file
  speedtest-cli --simple > "$RESULTS_FILE"
  # Read results into an array using mapfile
  mapfile -t results < "$RESULTS_FILE"
  # Extract and display specific metrics
  echo "$host Speed Test Results:\n Ping: ${results[0]} \n Download: ${results[1]} \n Upload: ${results[2]}"
  send_discord_msg "$host Speed Test Results:\n Ping: ${results[0]} \n Download: ${results[1]} \n Upload: ${results[2]}" 
  rm -rf $RESULTS_FILE
}

# #############################################################################
# The main function
# #############################################################################
f_main() {
  #date_hour=$(date +"%Y%m%d_%H%M%S")
  #send_discord_msg "$date_hour - Speedtest Started"
  speedtest
  #date_hour=$(date +"%Y%m%d_%H%M%S")
  #send_discord_msg "$date_hour - Speedtest Done"
}

# Call the main function.
f_main
exit





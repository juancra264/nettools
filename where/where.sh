#!/bin/bash
response=$(curl -s "https://ifconfig.co/json")
printf  "$response"
printf "\n"

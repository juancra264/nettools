#!/bin/bash
response=$(curl -s "http://ip-api.com/${1}")
if [ "$response" = '{"errors":{"detail":"Page not found"}}' ];
then
    printf "IP: ${1}\n Info: Not Found"
else
    printf  "IP: ${1}\n Info: $response"
fi
printf "\n"

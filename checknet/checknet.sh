#!/bin/bash
## Set some Colors
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

echo "*************************************************************************"
echo "IP Configured"
ipconfig | grep IPv4

echo "*************************************************************************"
echo "Public IP:"
curl -sS ifconfig.co/json -o response.json
jq '.ip' response.json
jq '.asn_org' response.json

rm response.json

echo "*************************************************************************"
echo "Test Ping using IP (Cloudflare DNS 1.1.1.1)"
ping 1.1.1.1 -i 0.2 -c 20 -s 1000 | grep -Ei "packet|round"

echo "*************************************************************************"
echo "Test Ping using Hostname DNS (www.google.com)"
ping www.google.com -i 0.2 -c 20 -s 1000 | grep -Ei "packet|round"

echo "*************************************************************************"
echo "DNS Test to Cloudflare DNS 1.1.1.1."
output=$(dig @1.1.1.1 www.google.com | grep status)
# Use the if statement to check the output
if echo "$output" | grep -q "NOERROR"; then
    echo "DNS response ${green}OK${reset}"
else
    echo "DNS response ${red}FAIL${reset}"
fi

echo "*************************************************************************"
echo "DNS Test to Google DNS"
output=$(dig @8.8.8.8 www.google.com | grep status)
# Use the if statement to check the output
if echo "$output" | grep -q "NOERROR"; then
    echo "DNS response ${green}OK${reset}"
else
    echo "DNS response ${red}FAIL${reset}"
fi

echo "*************************************************************************"
echo "DNS Test to Mimecast DNS"
output=$(dig @41.74.203.10 www.google.com | grep status)
# Use the if statement to check the output
if echo "$output" | grep -q "NOERROR"; then
    echo "DNS response ${green}OK${reset}"
else
    echo "DNS response ${red}FAIL${reset}"
fi
output=$(dig @41.74.203.11 www.google.com | grep status)
# Use the if statement to check the output
if echo "$output" | grep -q "NOERROR"; then
    echo "DNS response ${green}OK${reset}"
else
    echo "DNS response ${red}FAIL${reset}"
fi

echo "*****************************************************************************"
read -r -p "Run a speedtest to Internet? [y/N]" -n 1
echo # (optional) move to a new line
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "*************************************************************************"
    echo "Speedtest for the Link to Internet"
    if [[ "$(uname -o)" == "Cygwin" ]]; then
        ./speedtest
    else
        speedtest
    fi
fi


read -r -p "Run a Traceroute to Cloudflare DNS 1.1.1.1? [y/N]" -n 1
echo # (optional) move to a new line
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "*************************************************************************"
    echo "Traceroute"
    if [[ "$(uname -o)" == "Cygwin" ]]; then
        tracert 1.1.1.1
    else
        traceroute 1.1.1.1
    fi
fi

echo "*****************************************************************************"
read -r -p "Run a Traceroute to Google? [y/N]" -n 1
echo # (optional) move to a new line
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Traceroute"
    if [[ "$(uname -o)" == "Cygwin" ]]; then
        tracert -d www.google.com
    else
        traceroute www.google.com
    fi
fi
    
echo "*****************************************************************************"

#!/bin/bash

# disconnect the netbird client
netbird down
# wait a sec
sleep 2
# reconnect the netbird client
netbird up
#wait a sec
sleep 10
# Check netbird client status
netbird status


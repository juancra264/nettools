#!/usr/bin/env python3

__author__ = 'Juan Carlos Ramirez Angel'
__copyright__ = '(c) RaDuTech 2025'
__version__ = '0.0.1'

#***********************************************************
# Library Load
#***********************************************************
import os
import sys
import csv
import time
import subprocess
import argparse
from datetime import datetime


#***********************************************************
# Funtions
#***********************************************************


#def ping(host):
#    """
#    Returns True if host responds to a ping request using
#    the fping OS package.
#    """
#    # Ping parameters as function of OS
#    cmd = subprocess.run(["fping", host],
#                         stdout=subprocess.PIPE,
#                         stderr=subprocess.STDOUT)
#    output = cmd.stdout.decode("utf-8").strip()
#    if "alive" in output:
#        return("UP")
#    else:
#        return("DOWN")


def ping(host):
    """
    Returns True if host responds to a ping request using
    the ping OS package.
    """
    # Ping parameters as function of OS
    cmd = subprocess.run(["ping", host, "-c 1", "-W 1"],
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT)
    output = cmd.stdout.decode("utf-8").strip()
    if "time" in output:
        return("UP")
    else:
        return("DOWN")


def pingmon(host):
    state = ping(host)
    started_time = datetime.now()
    started_time_f = started_time.strftime("%Y-%m-%d %H:%M:%S")
    # datetime object containing current date and time
    print(f"pingmon started... \n {host} is {state} at \t{started_time_f}")
    while(True):
        state_now = ping(host)
        if(state == state_now):
            time.sleep(1)
        else:
            now = datetime.now()
            now_f = now.strftime("%Y-%m-%d %H:%M:%S")
            diff = now - started_time
            if(state_now == "UP"):
                print(f" {host} change to UP at \t{now_f} time diff: {diff}")
            else:
                print(f" {host} change to DOWN at \t{now_f} time diff: {diff}")
            state = state_now
            started_time = now


def main():
    # parser = argparse.ArgumentParser(description='pingmon to a host/ip')
    # parser.add_argument('--host', help='host/ip to monitoring default 8.8.8.8', default="8.8.8.8")
    # args = parser.parse_args()
    try:
        ip = sys.argv[1]
        #pingmon(args.host)
        pingmon(ip)
    except (IndexError):
        print("Please, check the IP or hostname -> python3 pingmon.py [ip | hostname]")


#*****************************************************
#		MAIN
#*****************************************************
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        try:
            print("\npingmon stopped by keyboard interrupt")
            sys.exit(0)
        except SystemExit:
            os._exit(0)

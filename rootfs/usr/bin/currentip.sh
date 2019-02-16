#!/usr/bin/env bash

# Current timestamp and external ip
# added as cron:
# *     *     *     *     *     /usr/bin/currentip.sh

date > /vpn/current_external_ip.txt
curl ifconfig.co >> /vpn/current_external_ip.txt
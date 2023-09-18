#!/bin/bash

set -e

#ifconfig.me returns the ipv4 address instead of an ipv6 address
echo "{\"public_ip\":\"$(curl -sL4 ifconfig.me)\"}"

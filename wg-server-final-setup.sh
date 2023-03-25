#!/bin/bash

# check a user is root
if [ "$(id -u)" != 0 ]; then
  echo Please, run the script as root: \"sudo ./wireguard-setup-ubuntu\"
  exit 1
fi

# name and ip of a client
client='client1'
client_ip='10.8.0.2'

# add the peer's public key to the wireguard server
wg set wg0 private-key /etc/wireguard/private.key peer $(cat /tmp/$client-public.key) allowed-ips $client_ip


echo ----- status -----
wg

exit 0

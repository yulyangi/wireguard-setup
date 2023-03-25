#!/bin/bash

# check a user is root
if [ "$(id -u)" != 0 ]; then
  echo Please, run the script as root: \"sudo ./wireguard-setup-ubuntu\"
  exit 1
fi


echo ----- Installing WireGuard and Generating a Key Pair -----

# update the system and install wireguard
apt update -y && apt install wireguard -y

# create a private key for wireguard and change its permission
wg genkey > /etc/wireguard/private.key
sudo chmod go= /etc/wireguard/private.key

# create a public key
cat /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
cp /etc/wireguard/public.key /tmp/server-public.key


echo ----- Creating a WireGuard Server Configuration and Configuring Firewall-----

# assign public interface to a variable
eth=$(ip route list default | awk '{print $5}')

# create the configuration file
cat<<END> /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/private.key)
Address = 10.8.0.1/24
ListenPort = 51820
SaveConfig = true
PostUp = iptables -t nat -I POSTROUTING -o $eth -j MASQUERADE
PreDown = iptables -t nat -D POSTROUTING -o $eth -j MASQUERADE
END


echo ----- Adjusting the WireGuard Server’s Network Configuration -----

# configure forwarding traffic though wireguard server
# add line if it does not exist
if ! grep '^net.ipv4.ip_forward=1$' /etc/sysctl.conf; then
	echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
fi

# load the new values for the current terminal session
sysctl -p


echo ----- Starting the WireGuard Server -----

# enable and start wireguard
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service

exit 0

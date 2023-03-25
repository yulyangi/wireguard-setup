#!/bin/bash

# check a user is root
if [ "$(id -u)" != 0 ]; then
  echo Please, run the script as root: \"sudo ./wireguard-setup-ubuntu\"
  exit 1
fi

client_user='doge'
server_user='ubuntuuser'

# name and ip of a client
client='client1'
client_ip='10.8.0.2'

# public vpn server's ip address
ip_vpn_server='159.223.26.65'

# DNS resolver's ip address of vpn server
ip_dns_resolver='67.207.67.2'


echo ----- Installing WireGuard and Generating a Key Pair -----

# update the system and install wireguard
apt update -y && apt install wireguard -y && apt install resolvconf -y

# create a private key for wireguard and change its permission
wg genkey > /etc/wireguard/private.key
sudo chmod go= /etc/wireguard/private.key

# create a public key
cat /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
cp /etc/wireguard/public.key /tmp/$client-public.key

# copy the public key from the client to the server
sudo -u $client_user scp /tmp/$client-public.key $server_user@$ip_vpn_server:/tmp/$client-public.key

echo ----- Creating a WireGuard Server Configuration -----

# copy the public key from the wireguard server to the client
sudo -u $client_user scp $server_user@$ip_vpn_server:/tmp/server-public.key /tmp/server-public.key

# create the configuration file
cat<<END> /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $(cat /etc/wireguard/private.key)
Address = $client_ip/24
DNS = $ip_dns_resolver

[Peer]
PublicKey = $(cat /tmp/server-public.key) 
AllowedIPs = 0.0.0.0/0
Endpoint = $ip_vpn_server:51820
END


echo ----- Starting the WireGuard Server -----

# enable and start wireguard
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service

exit 0

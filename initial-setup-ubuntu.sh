#!/bin/bash

# check a user is root
if [ "$(id -u)" != 0 ]; then
  echo Please, run the script as root: \"sudo ./initial-setup-ubuntu.sh\"
  exit 1
fi

# update and the system
echo -----update and upgrade
apt update -y && apt upgrade -y

# disable firewall
echo -----disable ufw
systemctl stop ufw
systemctl disable ufw

# add swap
echo -----add 2G swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# making the swap file permanent
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# set a timezone
echo -----set Europe/Minsk time zone
timedatectl set-timezone Europe/Minsk

exit 0

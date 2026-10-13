#!/usr/bin/env bash
############################################################################
##                                                                        ##
##               RUN THIS AFTER FINISH CONFIGURING NIXOS                  ##
##                                                                        ##
############################################################################

set -euo pipefail

# Configure smbclient for printing
sudo mkdir -p /etc/samba
sudo touch /etc/samba/smb.conf
sudo systemctl restart cups

# Fonts
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.gnome.desktop.interface text-scaling-factor 0.95
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# VM
sudo install -d /etc/libvirt
sudo touch /etc/libvirt/network.conf

# Use iptables as the firewall backend for libvirt (default is nftables, which can cause issues with some VMs)
if sudo grep -qE '^[[:space:]]*#?[[:space:]]*firewall_backend[[:space:]]*=' /etc/libvirt/network.conf; then
  sudo sed -i -E \
    's/^[[:space:]]*#?[[:space:]]*firewall_backend[[:space:]]*=.*/firewall_backend = "iptables"/' \
    /etc/libvirt/network.conf
else
  echo 'firewall_backend = "iptables"' |
    sudo tee -a /etc/libvirt/network.conf >/dev/null
fi

# Start libvirt and enable it at boot
sudo systemctl enable --now libvirtd
sudo systemctl restart libvirtd

# Enable the default NAT network
sudo virsh net-autostart default
sudo virsh net-start default || true

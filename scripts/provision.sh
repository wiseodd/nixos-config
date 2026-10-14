#!/usr/bin/env bash
############################################################################
##                                                                        ##
##               RUN THIS AFTER FINISH CONFIGURING NIXOS                  ##
##                                                                        ##
############################################################################

set -euo pipefail

# Ensure Bash login shells load .bashrc
line='[[ -f ~/.bashrc ]] && source ~/.bashrc'
touch "$HOME/.bash_profile"
grep -qxF "$line" "$HOME/.bash_profile" ||
  printf '\n%s\n' "$line" >>"$HOME/.bash_profile"

# Source custom Bash config
line='[[ -f "$HOME/config/custom.bash" ]] && source "$HOME/config/custom.bash"'
touch "$HOME/.bashrc"
grep -qxF -- "$line" "$HOME/.bashrc" ||
  printf '\n%s\n' "$line" >>"$HOME/.bashrc"

# Fonts
gsettings set org.gnome.desktop.interface font-name 'Inter Display 11'
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# GTK applications
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita-Arrow'
gsettings set org.gnome.desktop.interface cursor-size 24

# Configure smbclient for printing
sudo mkdir -p /etc/samba
sudo touch /etc/samba/smb.conf
sudo systemctl restart cups

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

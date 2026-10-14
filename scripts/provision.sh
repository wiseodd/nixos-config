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

# Adwaita cursors
adwaita_cursors=/run/current-system/sw/share/icons/Adwaita/cursors
cursor_theme="${XDG_DATA_HOME:-$HOME/.local/share}/icons/Adwaita-Arrow"
cursor_dir="$cursor_theme/cursors"

if [[ ! -e "$adwaita_cursors/left_ptr" ]]; then
  echo "Error: Adwaita cursor theme not found" >&2
  exit 1
fi

mkdir -p "$cursor_dir"

cat >"$cursor_theme/index.theme" <<'EOF'
[Icon Theme]
Name=Adwaita-Arrow
Comment=Adwaita cursors with arrow for clickable areas
Inherits=Adwaita
EOF

for cursor in pointer hand hand2 pointing_hand link; do
  ln -sfn "$adwaita_cursors/left_ptr" "$cursor_dir/$cursor"
done

# GTK applications
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita-Arrow'
gsettings set org.gnome.desktop.interface cursor-size 24

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

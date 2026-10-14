# Personal NixOS Config

Step-by-step:

1. Install NixOS
2. Add git and stow to `/etc/nixos/configuration.nix` (use sudoedit):
   ```nix
   # ...

   environment.systemPackages = with pkgs; [
      neovim
      wget
      git
      stow
   ]

   # ...
   ```
 3. Install git and stow
   ```sh
   sudo nixos-rebuild switch
   ```
4. Clone this repo
   ```sh
   git clone git@github.com:wiseodd/nixos-config.git ~/nixos-config
   ```
5. Copy machine-specific config
   ```sh
   cd nixos-config
   cp /etc/nixos/hardware-configuration.nix nixos
   ```
6. Check `hardware-configuration.nix`, copy the UUID for swap partition, and use put it here `nixos/hosts/home.nix`, replacing the existing one. A new host can also be created.
   - E.g., if in `hardware-configuration.nix` it says: `/dev/mapper/luks-bcf1c770-4fc1-4c9b-8fde-4cd7b9c6ccba`, then copy the string after `luks-` and put it in `luks-...` and `/dev/disk/by-uuid/...` in `hosts/home.nix`.
7. Back up the existing config
   ```sh
   sudo mv /etc/nixos /etc/nixos-BAK
   sudo mkdir /etc/nixos
   ```
8 Link the repo files
   ```sh
   sudo stow -t /etc/nixos nixos
   ```
9. Install and reboot
   ```sh
   sudo nixos-rebuild switch
   systemctl reboot
   ```

# Personal NixOS Config

Step-by-step:

1. Install NixOS
2. Add git and stow to `/etc/nixos/configuration.nix` (use sudo):
   ```nix
   ...

   environment.systemPackages = with pkgs; [
      neovim
      wget
      git
      stow
   ]

   ...
   ```
3. Run:
   ```sh
   # Install git and stow
   sudo nixos-rebuild switch

   # Clone this repo
   git clone git@github.com:wiseodd/nixos-config.git ~/nixos-config

   # Copy machine-specific config
   cp /etc/nixos/hardware-configuration ~/nixos-config

   # Back up the existing config
   sudo mv /etc/nixos /etc/nixos-BAK
   sudo mkdir /etc/nixos

   # Link the repo files
   stow -t /etc/nixos .

   # Install git and stow
   sudo nixos-rebuild switch
   ```
4. Reboot

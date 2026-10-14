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
3. Run:
   ```sh
   # Install git and stow
   sudo nixos-rebuild switch

   # Clone this repo
   git clone git@github.com:wiseodd/nixos-config.git ~/nixos-config

   # Copy machine-specific config
   cd nixos-config
   cp /etc/nixos/hardware-configuration nixos

   # Back up the existing config
   sudo mv /etc/nixos /etc/nixos-BAK
   sudo mkdir /etc/nixos

   # Link the repo files
   sudo stow -t /etc/nixos nixos

   # Install git and stow
   sudo nixos-rebuild switch
   ```
4. Reboot

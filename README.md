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
5. Copy machine-specific config: (change `${YOUR_HOST_NAME}`)
   ```sh
   cd nixos-config
   cp /etc/nixos/hardware-configuration.nix nixos/hosts/${YOUR_HOST_NAME}-hardware-configuration.nix
   ```
6. Check `/etc/nixos/configuration.nix`, copy the line that looks like this (the UUID will be **different!**):
   ```nix
   boot.initrd.luks.devices."luks-bcf1c770-4fc1-4c9b-8fde-4cd7b9c6ccba".device = "/dev/disk/by-uuid/bcf1c770-4fc1-4c9b-8fde-4cd7b9c6ccba";
   ```
   into `nixos/hosts/${YOUR_HOSTNAME}.nix`.
7. Assuming `${YOUR_HOSTNAME}` is either `home` or `office`, then it's good to go. Otherwise, edit `flake.nix` to add a new host.
8. Back up the existing config
   ```sh
   sudo mv /etc/nixos /etc/nixos-BAK
   sudo mkdir /etc/nixos
   ```
9 Link the repo files
   ```sh
   sudo stow -t /etc/nixos nixos
   ```
10. Install and reboot.
   ```sh
   cd nixos
   sudo nixos-rebuild switch --flake .#{YOUR_HOST_NAME}
   systemctl reboot
   ```

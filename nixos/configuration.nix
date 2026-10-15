{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/apps.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/fonts.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/system.nix
    ./modules/users.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # DO NOT CHANGE THIS
  system.stateVersion = "26.05";
}

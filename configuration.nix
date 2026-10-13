{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.firewall.allowedTCPPorts = [
    22  # SSH
  ];

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."akristiadi" = {
    isNormalUser = true;
    description = "Agustinus Kristiadi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    stow
    nautilus
    wl-clipboard
    grim
    slurp
    mako
    fuzzel
    wezterm
    starship
    firefox
    zathura
  ];

  # Window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Login manager
  programs.regreet.enable = true;

  # ## Fallback to SDDM
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "akristiadi" ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.iosevka
  ];

  # List services that you want to enable:

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    swaylock.enableGnomeKeyring = true;
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # DO NOT CHANGE THIS
  system.stateVersion = "26.05";
}

{ config, inputs, pkgs, ... }:

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

  hardware.bluetooth.enable = true;

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
    extraGroups = [ 
      "networkmanager"
      "wheel" 
      "libvirtd"
    ];
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
    wezterm
    starship
    zathura
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Browsers
    firefox
    firefoxpwa

    # CLI tools
    zoxide
    ripgrep
    lazygit
    fzf
    fd
    skim  # sk in Arch

    # Development and language servers
    tree-sitter 
    ty
    lua-language-server
    stylua
    ruff
    texlab
    tinymist
    typstyle
    marksman
    eslint
    prettier
    dprint
    tailwindcss-language-server
    typescript-language-server
    yaml-language-server
    taplo
    harper
    shfmt

    # Languages and runtimes
    lua
    luarocks
    nodejs
    typescript
    pyenv
    tk
    uv

    # Documents and typesetting
    typst
    texlive.combined.scheme-full
    pandoc
    pdftk

    # Applications
    proton-vpn            # Current official Proton VPN client
    megasync

    # Webcam
    v4l-utils
    usbmuxd
    libimobiledevice

    # Printing
    samba                 # Provides smbclient
    cups

    # Virtualization
    qemu_full
    libvirt
    virt-manager
    dnsmasq

    # Utils
    ddcutil
    flatpak
  ];

  # Window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Login manager
  services.displayManager.ly.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "akristiadi" ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.iosevka
  ];

  services.flatpak.enable = true;
  services.printing.enable = true;
  services.usbmuxd.enable = true;
  
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

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  harware.i2c.enable = true;  # For ddcutil

  # KVM/QEMU
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  programs.virt-manager.enable = true;

  # v4l2loopback: use the module built for this kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernelModules = [ "v4l2loopback" ];

  # DO NOT CHANGE THIS
  system.stateVersion = "26.05";
}

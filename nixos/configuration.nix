{
  config,
  inputs,
  pkgs,
  ...
}:

{
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

  hardware.graphics.enable = true;
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

  console = {
    useXkbConfig = true;
    earlySetup = true;
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
    packages = with pkgs; [ ];
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
    stdenv.cc
    gcc
    gnumake
    stow
    nautilus
    sushi
    loupe
    evince
    wl-clipboard
    grim
    slurp
    mako
    wezterm
    starship
    zathura
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wlr-utils

    # GTK stuffs
    glib
    dconf
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
    adw-gtk3

    # Browsers
    firefox
    firefoxpwa

    # CLI tools
    zoxide
    ripgrep
    lazygit
    fzf
    fd
    skim # sk in Arch

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
    nixfmt

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
    proton-vpn # Current official Proton VPN client
    megasync

    # Webcam
    v4l-utils
    usbmuxd
    libimobiledevice

    # Printing
    samba # Provides smbclient
    cups

    # Virtualization
    qemu_full
    libvirt
    virt-manager
    dnsmasq

    # Utils
    ddcutil
    flatpak
    udiskie
    networkmanagerapplet
  ];

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      inter
      corefonts
    ];
  };

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

  services.flatpak = {
    enable = true;

    packages = [
      "us.zoom.Zoom"
      "com.obsproject.Studio"
      "com.obsproject.Studio.Plugin.DroidCam"
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.slack.Slack"
      "com.budgetwithbuckets.Buckets"
      "org.zotero.Zotero"
      "com.vscodium.codium"
      "org.onlyoffice.desktopeditors"
    ];

    overrides.settings = {
      "us.zoom.Zoom".Context.filesystems = [
        "/home/akristiadi/.config/zoomus.conf"
      ];

      "com.obsproject.Studio".Context.filesystems = [
        "/run/usbmuxd"
      ];
    };
  };

  # GTK settings
  programs.dconf.enable = true;

  # Printing
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

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
  hardware.i2c.enable = true; # For ddcutil

  # KVM/QEMU
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  programs.virt-manager.enable = true;

  # v4l2loopback: use the module built for this kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  services.usbmuxd.enable = true; # For connecting iPhone with USB

  # Configure screensharing
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };

    wlr.settings.screencast = {
      chooser_type = "simple";
      chooser_cmd = "${
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.wlr-utils
      }/bin/wlr-chooser --both --layout grid --grid 4x3";
    };
  };

  # DO NOT CHANGE THIS
  system.stateVersion = "26.05";
}

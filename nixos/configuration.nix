{
  config,
  inputs,
  pkgs,
  ...
}:

let
  username = "akristiadi";
in
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
    keyMap = "us";
    useXkbConfig = false;
    earlySetup = true;
  };

  # Define a user account
  users.users.${username} = {
    isNormalUser = true;
    description = "Agustinus Kristiadi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [ ];
  };

  # Setup autologin. Initial boot is secured by disk encryption already.
  services.displayManager.autoLogin = {
    enable = true;
    user = username;
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
    unzip
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
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.euro-office-desktopeditors

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
    seahorse
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
      "org.zotero.Zotero"
      "com.vscodium.codium"
    ];

    overrides.settings = {
      "org.zotero.Zotero"."Session Bus Policy"."org.freedesktop.secrets" = "talk";

      "us.zoom.Zoom".Context.filesystems = [
        "/home/akristiadi/.config/zoomus.conf"
      ];

      "com.obsproject.Studio".Context.filesystems = [
        "/run/usbmuxd"
      ];

      "com.vscodium.codium".Environment = {
        XDG_SESSION_TYPE = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };

      "com.github.IsmaelMartinez.teams_for_linux".Environment = {
        XDG_SESSION_TYPE = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };

      "com.slack.Slack".Environment = {
        XDG_SESSION_TYPE = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };
    };
  };

  # GTK settings
  programs.dconf.enable = true;

  # Printing
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

  # Keyring and autounlock using LUKS passphrase
  # NOTE: Change gnome-keyring password using seahorse to match LUKS passphrase
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly-autologin.rules.auth = {
    systemd-loadkey = {
      order = 10250;
      control = "optional";
      modulePath = "${pkgs.systemd}/lib/security/pam_systemd_loadkey.so";
    };

    gnome-keyring = {
      order = 10260;
      control = "optional";
      modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
    };
  };
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    swaylock.enableGnomeKeyring = true;
  };

  # OpenSSH server, useful for rsync back and forth with a cluster
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  hardware.i2c.enable = true; # For ddcutil

  # KVM/QEMU
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  programs.virt-manager.enable = true;

  boot = {
    # v4l2loopback: use the module built for this kernel
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];

    # Plymouth graphical bootscreen
    plymouth = {
      enable = true;
      extraConfig = ''
        [Daemon]
        DeviceScale=an-integer-scaling-factor
      '';
    };

    # Silent boot
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Don't show bootloader
    loader.timeout = 0;
  };

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
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wlr-utils
      }/bin/wlr-chooser --both --grid 4x3";
    };
  };

  # DO NOT CHANGE THIS
  system.stateVersion = "26.05";
}

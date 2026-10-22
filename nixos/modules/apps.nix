{
  inputs,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    stdenv.cc
    gcc
    gnumake
    zlib
    unzip
    stow
    nautilus
    file-roller
    sushi
    loupe
    evince
    wl-clipboard
    grim
    slurp
    mako
    starship
    zathura
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.wlr-utils

    # Terminal
    alacritty
    foot

    # GTK stuffs
    glib
    dconf
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
    adw-gtk3

    # Browsers
    brave
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
    alsa-utils
    pavucontrol
    ddcutil
    flatpak
    udiskie
    seahorse
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "akristiadi" ];
  };

  # Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  programs.virt-manager.enable = true;

  # Flatpak apps
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      "us.zoom.Zoom"
      "com.obsproject.Studio"
      "com.obsproject.Studio.Plugin.DroidCam"
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.slack.Slack"
      "org.zotero.Zotero"
      "com.vscodium.codium"
      "com.budgetwithbuckets.Buckets"
    ];

    overrides.settings = {
      global.Environment.TZ = "America/Toronto";

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

      "com.budgetwithbuckets.Buckets" = {
        Context.sockets = [
          "wayland"
          "x11"
        ];

        Environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        };
      };
    };
  };

  # Default applications
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "inode/directory" = "org.gnome.Nautilus.desktop";
  };
}

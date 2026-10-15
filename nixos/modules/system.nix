{
  inputs,
  config,
  pkgs,
  ...
}:
{
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

  # Enable launching binaries from ~/.local/bin
  environment.localBinInPath = true;
  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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
}

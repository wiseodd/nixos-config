{
  inputs,
  config,
  pkgs,
  lib,
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
  security.polkit.enable = true;
  security.pam.services = {
    greetd = {
      enableGnomeKeyring = true;
      # Retrieve the LUKS passphrase during greetd autologin
      # This unlocks gnome keyring using LUKS passphrase
      rules.session.fde_boot_pw = {
        order = config.security.pam.services.greetd.rules.session.gnome_keyring.order - 10;
        enable = true;
        control = "optional";
        modulePath = "${pkgs.pam_fde_boot_pw}/lib/security/pam_fde_boot_pw.so";
        args = [ "inject_for=gkr" ];
      };
    };
    login.enableGnomeKeyring = true; # For noctalia locker
  };
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";
  systemd.services.greetd.serviceConfig.KeyringMode = lib.mkForce "inherit";

  # Use root password for sudo
  security.sudo.extraConfig = ''
    Defaults rootpw
  '';

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Configure screensharing
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}

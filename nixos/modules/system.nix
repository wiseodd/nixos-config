{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # Rustify things
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults rootpw
    '';
  };

  environment.systemPackages = with pkgs; [
    (lib.hiPrio pkgs.uutils-coreutils-noprefix)
    (lib.hiPrio pkgs.uutils-diffutils)
    (lib.hiPrio pkgs.uutils-findutils)
  ];

  # Region things
  time.timeZone = "America/Toronto";
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

  # Global Python: a uv-managed venv at ~/.venv (pip-installable, PyPI wheels
  # work via nix-ld). Create it once with:
  #   uv venv --seed --managed-python --python 3.14 ~/.venv
  environment.sessionVariables.PATH = [ "$HOME/.venv/bin" ];

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

  # SSL certificate location, otherwise things like Python's requests will fail
  environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-bundle.crt";

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

  # CPU scheduling
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_bpfland";
    extraArgs = [ ];
  };
}

{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # Window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
  };

  # Enable hyprland but disable UWSM version
  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  environment.systemPackages = [
    # Use nicer, newer Hyprland screen sharing picker
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprland-preview-share-picker
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.noctalia-greeter
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Papirus";
        font-name = "Inter Display 11";
        document-font-name = "Inter Display 11";
        monospace-font-name = "JetBrainsMono NF 11";
      };
    }
  ];

  # Display manager
  services.displayManager = {
    noctalia-greeter = {
      enable = true;
      package =
        inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia-greeter;
      settings = {
        keyboard.layout = "us";
        cursor = {
          size = 24;
          name = "Adwaita";
          path = pkgs.adwaita-icon-theme;
        };
      };
    };

    defaultSession = "hyprland";
    autoLogin = {
      enable = true;
      user = "akristiadi";
    };
  };

  # Screen sharing and screenshot support
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    # Configure portal chain/fallback if needed
    config.common.default = "*";

    config.hyprland = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
    };
  };
}

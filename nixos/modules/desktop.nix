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

  programs.hyprland.enable = true;
  environment.systemPackages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprland-preview-share-picker
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

  # Login manager
  services.displayManager = {
    ly.enable = true;

    sessionPackages = [
      config.programs.hyprland.package
    ];

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

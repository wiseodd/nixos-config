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
      enable = false;
      user = "akristiadi";
    };
  };

  # Screen sharing and screenshot support
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
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

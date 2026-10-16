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

    # SDDM Theme
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
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
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
      settings.Theme = {
        CursorTheme = "Adwaita";
        CursorSize = 24;
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

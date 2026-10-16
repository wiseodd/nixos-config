{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # Enable hyprland but disable UWSM version
  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  environment.systemPackages = [
    # Use nicer, newer Hyprland screen sharing picker
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprland-preview-share-picker
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia-greeter
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
  services =
    let
      user = "akristiadi";
    in
    {
      displayManager = {
        noctalia-greeter = {
          enable = true;
          package =
            inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia-greeter;
          passwordless-sync-users = [ user ];
          settings = {
            user.default = user;
            session.default = "hyprland";
            appearance = {
              scheme = "Synced";
              hide_logo = true;
              font_family = "Inter Display";
            };
            output.scale = 1.6;
            keyboard.layout = "us";
            cursor = {
              size = 38;
              name = "Adwaita";
              path = pkgs.adwaita-icon-theme;
            };
          };
        };
      };

      # Autologin
      greetd.settings.initial_session = {
        command = "${pkgs.hyprland}/bin/start-hyprland";
        user = user;
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

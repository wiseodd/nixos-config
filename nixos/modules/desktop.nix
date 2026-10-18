{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./window-managers/umbriel.nix
  ];

  # GTK interface
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

  # Display manager / login screen
  environment.systemPackages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.noctalia-greeter
  ];

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
    };
}

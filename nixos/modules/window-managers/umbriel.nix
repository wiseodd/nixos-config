{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.umbriel.nixosModules.default ];

  programs.umbriel.enable = true;

  # Screen sharing and screenshot support
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config.umbriel = {
      default = [
        "umbriel"
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "umbriel" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "umbriel" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
    };
  };

  # Autologin
  services.greetd.settings.initial_session = {
    command = "${config.programs.umbriel.package}/bin/start-umbriel";
    user = "akristiadi";
  };
}

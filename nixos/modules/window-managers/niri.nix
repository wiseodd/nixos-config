{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];

  # Screen sharing and screenshot support
  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];

    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];

      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
    };
  };

  # Autologin
  services.greetd.settings.initial_session = {
    command = "${config.programs.niri.package}/bin/niri-session";
    user = "akristiadi";
  };
}

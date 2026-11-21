{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  # Use nicer, newer Hyprland screen sharing picker
  environment.systemPackages = [
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprland-preview-share-picker
  ];

  # Screen sharing and screenshot support
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    # Configure portal chain/fallback if needed
    config.common.default = "*";

    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  # Autologin
  services.greetd.settings.initial_session = {
    command = "${pkgs.hyprland}/bin/start-hyprland";
    user = "akristiadi";
  };
}

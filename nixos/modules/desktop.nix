{
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

  # Login manager
  services.displayManager.ly.enable = true;

  # Setup autologin. Initial boot is secured by disk encryption already.
  services.displayManager.autoLogin = {
    enable = true;
    user = "akristiadi";
  };
}

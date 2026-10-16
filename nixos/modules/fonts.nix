{
  config,
  pkgs,
  ...
}:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      inter
      corefonts
    ];
  };

  environment.sessionVariables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
    NIXOS_OZONE_WL = "1";
  };

  fonts.fontconfig = {
    enable = true;
    hinting = {
      enable = true;
      style = "slight"; # Best for preserving font geometry alongside darkening
    };
    subpixel = {
      rgba = "none"; # Enforces grayscale anti-aliasing to stop color fringing
    };
  };
}

{
  config,
  pkgs,
  ...
}:
{
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  hardware.i2c.enable = true; # For ddcutil

  # For connecting iPhone/iPad with USB
  services.usbmuxd.enable = true;
}

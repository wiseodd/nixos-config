{
  config,
  pkgs,
  ...
}:
{
  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Bootloader
    loader = {
      limine.enable = true;
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    # Plymouth graphical bootscreen
    plymouth = {
      enable = true;
      extraConfig = ''
        [Daemon]
        DeviceScale=an-integer-scaling-factor
      '';
    };

    # Silent boot
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # v4l2loopback: use the module built for this kernel
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };
}

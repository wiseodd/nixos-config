{ pkgs, ... }: {
  boot.initrd.luks.devices."luks-66289d23-12cf-42aa-b83d-5b58fb216e3a".device =
    "/dev/disk/by-uuid/66289d23-12cf-42aa-b83d-5b58fb216e3a";

  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-toshiba-estudio ];
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];

  environment.etc."samba/smb.conf".text = ''
    [global]
    client min protocol = SMB2
    client max protocol = SMB3
  '';
}

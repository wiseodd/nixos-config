{ pkgs, ... }: {
  boot.initrd.luks.devices."luks-66289d23-12cf-42aa-b83d-5b58fb216e3a".device =
    "/dev/disk/by-uuid/66289d23-12cf-42aa-b83d-5b58fb216e3a";

  networking.hostName = "nixos-office";

  services.printing = {
    enable = true;
    # The upstream PPD hardcodes the filter's /nix/store path. CUPS copies the
    # PPD when the printer is added, so a flake update leaves it pointing at a
    # garbage-collected path. Use the bare filter name so CUPS resolves it via
    # its ServerBin, which is stable.
    drivers = [
      (pkgs.cups-toshiba-estudio.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          for ppd in $(find $out/share/cups/model -type f); do
            if [[ $ppd == *.gz ]]; then
              gunzip -c "$ppd" | sed "s|$out/lib/cups/filter/||g" | gzip -9n > "$ppd.tmp"
            else
              sed "s|$out/lib/cups/filter/||g" "$ppd" > "$ppd.tmp"
            fi
            mv "$ppd.tmp" "$ppd"
          done
        '';
      }))
    ];
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

{ pkgs, inputs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  programs.zsh.enable = true;

  users.users.akristiadi = {
    isNormalUser = true;
    home = "/home/akristiadi";
    extraGroups = [ "docker" "lxd" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$etxS4YjcPwHONzfo$BKBh1Q7AZhT5avCSIp6EjNHDCXGd7Yx6Qv6d32oV34edBz/vLAOLjpRttsyIuFhz8jNyfQYJNM6VFX5Yysbav/";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8lhkof6RkQBjvQLVdvGUS3EtYgDVpgB7Sk+w/MAWnGB9yK4HYjapPC6vbxYqYbNV8mfH32xfgrUxuLXIZKtTIbFO5YxOYhI+0vYzxP9wd5KlCdXwSVkUeegKxR5ZGC8tW3JBiE2ajeuMfVfJyEx9/5G4ZgYsDHZMgmUqxBXnKSwnUMOfnIAoO4rVuI5Wi5OSW/9BZzOMNPSLSSdp5m560Juh/0EPrE3F+BjCBuGtoTNVEIT7h5YAUFf5yAo4A0iECY2G7cBFk818lhC4yE5ZgJPqROWOINNjCVBGVNqtS/kD6TQJ0UTNREzS4w/q0YQzqOY/o1SoJwlZs6cAMxCs9 wiseodd@wmba"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}

{
  config,
  pkgs,
  ...
}:
{
  # Define a user account
  users.users."akristiadi" = {
    isNormalUser = true;
    description = "Agustinus Kristiadi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [ ];
  };
}

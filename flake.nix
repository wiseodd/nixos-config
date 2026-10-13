{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.aknixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
      ];
    };
  };
}

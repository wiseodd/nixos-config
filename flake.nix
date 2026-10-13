{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        ({ pkgs, ... }: {
          nix.settings = {
            substituters = [ "https://noctalia.cachix.org" ];
            extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
          };
        })
      ];
    };
  };
}

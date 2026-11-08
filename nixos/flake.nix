{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.8.0";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/home.nix
            ./hosts/home-hardware-configuration.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.noctalia-greeter.nixosModules.default
          ];
        };

        office = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/office.nix
            ./hosts/office-hardware-configuration.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.noctalia-greeter.nixosModules.default
          ];
        };
      };
    };
}

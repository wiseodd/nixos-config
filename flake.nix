{
  description = "NixOS systems and tools by akristiadi";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Used to get ibus 1.5.29 which has some quirks we want to test.
    nixpkgs-old-ibus.url = "github:nixos/nixpkgs/e2dd4e18cc1c7314e24154331bae07df76eb582f";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # snapd
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # I think technically you're not supposed to override the nixpkgs
    # used by neovim but recently I had failures if I didn't pin to my
    # own. We can always try to remove that anytime.
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    # # Non-flakes
    # nvim-conform.url = "github:stevearc/conform.nvim/v7.1.0";
    # nvim-conform.flake = false;
    # nvim-dressing.url = "github:stevearc/dressing.nvim";
    # nvim-dressing.flake = false;
    # nvim-gitsigns.url = "github:lewis6991/gitsigns.nvim/v0.9.0";
    # nvim-gitsigns.flake = false;
    # nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    # nvim-lspconfig.flake = false;
    # nvim-lualine.url ="github:nvim-lualine/lualine.nvim";
    # nvim-lualine.flake = false;
    # nvim-nui.url = "github:MunifTanjim/nui.nvim";
    # nvim-nui.flake = false;
    # nvim-plenary.url = "github:nvim-lua/plenary.nvim";
    # nvim-plenary.flake = false;
    # nvim-telescope.url = "github:nvim-telescope/telescope.nvim/0.1.8";
    # nvim-telescope.flake = false;
    # nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter/v0.9.3";
    # nvim-treesitter.flake = false;
    # nvim-web-devicons.url = "github:nvim-tree/nvim-web-devicons";
    # nvim-web-devicons.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      (final: prev: rec {
        # gh CLI on stable has bugs.
        gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;

        ibus = ibus_stable;
        ibus_stable = inputs.nixpkgs.legacyPackages.${prev.system}.ibus;
        ibus_1_5_29 = inputs.nixpkgs-old-ibus.legacyPackages.${prev.system}.ibus;
        ibus_1_5_31 = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.ibus;
      })
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
      system = "aarch64-linux";
      user   = "akristiadi";
    };

  };
}

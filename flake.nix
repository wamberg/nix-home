{
  description = "Personal system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neovim-flake.url = "github:wamberg/neovim-flake";
  };

  outputs = inputs @ { nixpkgs, home-manager, nixos-hardware, neovim-flake, ... }:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          neovim-flake.overlay."${system}"
        ];
      };

      system = "x86_64-linux";
    in
    {
      homeManagerConfigurations = {
        wamberg = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "wamberg";
          homeDirectory = "/home/wamberg";
          stateVersion = "21.05";
          configuration = {
            imports = [
              ./users/wamberg/home.nix
            ];
          };
        };
      };
      nixosConfigurations = {
        lofty = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./system/configuration.nix
            nixos-hardware.nixosModules.dell-xps-13-9380
          ];
        };
      };
    };
}

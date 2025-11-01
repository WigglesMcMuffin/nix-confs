{
  description = "Base OS Flake";

  inputs = {
      nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-24.11";
      sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, sops-nix, home-manager, ... }@inputs: {
    nixosConfigurations = {
      tmoss-mini-nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
          };
        };
        modules = [
          ./hosts/mini
        ];
      };
      tmoss-desktop-nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-stable = import nixpkgs-stable {
            inherit system;
          };
        };
        modules = [
          ./hosts/desktop
        ];
      };
    };

    homeConfigurations = {
      "tmoss@tmoss-mini-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [./home/tmoss/home.nix];
        extraSpecialArgs = { inherit inputs; };
      };
      "tmoss@tmoss-desktop-nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [./home/tmoss/home.nix];
        extraSpecialArgs = { inherit inputs; };
      };
    };
  };
}

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
        };
        modules = [
          ./hosts/mini
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wezterm-name = "mini-home";
              };
              users.tmoss.imports = [ ./home/tmoss ];
            };
          }
        ];
      };
      kea = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/desktop
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wezterm-name = "desktop-home";
              };
              users.tmoss.imports = [ ./home/tmoss ./home/tmoss/hyprland.nix ./home/tmoss/home.nix ];
            };
          }
        ];
      };
    };
  };
}

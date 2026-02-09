{
  description = "Base OS Flake";

  inputs = {
      nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:NixOs/nixpkgs/nixos-24.11";
      sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, sops-nix, disko, home-manager, ... }@inputs: {
    homeManagerModules = {
      nvim = import ./home/config/nvim;
      fetch-mutable-files = import ./home/modules/fetch-mutable-files.nix;
      users = {
        tmoss = import ./home/tmoss;
      };
    }; 
    nixosConfigurations = {
      tui = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/tui
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wezterm-name = "tui-home";
              };
              users.tmoss.imports = [ ./home/modules/fetch-mutable-files.nix ./home/tmoss ];
            };
          }
        ];
      };
      kahu = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/kahu
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wezterm-name = "kahu-home";
              };
              users.tmoss.imports = [ ./home/modules/fetch-mutable-files.nix ./home/tmoss ];
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
          ./hosts/kea
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                wezterm-name = "kea-home";
              };
              users.tmoss.imports = [ ./home/modules/fetch-mutable-files.nix ./home/tmoss ./home/tmoss/hyprland.nix ./home/tmoss/home.nix ];
            };
          }
        ];
      };
    };
  };
}

{ config, lib, pkgs, pkgs-stable, ... }: let
  username = "tmoss";
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
    ];

  nixpkgs.overlays = [
    (final: prev: {
      clipse = prev.clipse.override rec {
        buildGoModule = args: pkgs.buildGoModule ( args // {
          version = "1.2.0";
          src = final.fetchFromGitHub {
            owner = "savedra1";
            repo = "clipse";
            rev = "v1.2.0";
            hash = "sha256-17ZzmgXm8aJGG4D48wJv+rBCvJZMH3b2trHwhTqwb8s=";
          };
          vendorHash = "sha256-6lOUSRo1y4u8+8G/L6BvhU052oYrsthqxrsgUtbGhYM=";
          tags = [ "wayland" ];
          env = {
            GCO_ENABLED = "0";
          };
        });
      };
    })
    (final: prev: {
      wezterm = prev.wezterm.overrideAttrs (old: rec {
        version = "0-unstable-2026-01-29-overlaypatch";
        src = pkgs.fetchFromGitHub {
          owner = "JafarAbdi";
          repo = "wezterm";
          rev = "c1c57af8556fd78a51f9556bdbbb56c3c38e0b57";
          fetchSubmodules = true;
          hash = "sha256-cH7kdJ1h+5qTsd4GG7JFg+o8gNm42VVEAdbR3zE1ieE=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-o6VEpAzNUPtONbtI63DXyGWiLDVU9q8IZethlzz5duk=";
        };
      });
    })
  ];

  home = let
    stable = with pkgs-stable; [

    ];

    unstable = with pkgs; [
      qutebrowser
      fzf
      rofi
      gawk
      clipse
      obsidian
      ripgrep
      go-task
      eza
    ];

    dotfiles = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."dotfiles".path;
  in {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    packages = stable ++ unstable;

    file = {
      # Extra Utils
      "bin/sessionizer".source = ./sessionizer;
    };

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "qutebrowser";
      # l10n
      LANG    = "en_US.UTF-8";
      LC_ALL  = "en_US.UTF-8";
      # Improve less layout
      LESS    = "--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS";
    };
  };

  services.clipse.enable = true;

  programs = {
    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

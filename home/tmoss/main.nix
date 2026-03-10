{ config, lib, pkgs, pkgs-stable, ... }: let
  username = "tmoss";
in {

  nixpkgs.overlays = [
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
      fzf
      gawk
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
      # TODO: Add ~/.ssh/config to include ~/.ssh/confid.d/
      # Extra Utils
      "bin/sessionizer".source = ./sessionizer;
    };

    sessionVariables = {
      EDITOR = "nvim";
      # l10n
      LANG    = "en_US.UTF-8";
      LC_ALL  = "en_US.UTF-8";
      # Improve less layout
      LESS    = "--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS";
    };
  };

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

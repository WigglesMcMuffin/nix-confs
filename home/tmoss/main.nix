{ config, lib, pkgs, pkgs-stable, ... }: let
  username = "tmoss";
in {

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

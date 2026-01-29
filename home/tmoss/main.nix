{ config, lib, pkgs, pkgs-stable, ... }: let
  username = "tmoss";
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
    ];

  nixpkgs.overlays = [
    (final: prev: {
      clipse = let
        version = "1.2.0";
        src = pkgs.fetchFromGitHub {
          owner = "savedra1";
          repo = "clipse";
          rev = "v${version}";
          hash = "sha256-17ZzmgXm8aJGG4D48wJv+rBCvJZMH3b2trHwhTqwb8s=";
        };
      in
        prev.clipse.override rec {
          buildGoModule = args: pkgs.buildGoModule ( args // {
            inherit src version;
            vendorHash = "sha256-6lOUSRo1y4u8+8G/L6BvhU052oYrsthqxrsgUtbGhYM=";

            tags = [ "wayland" ];

            env = {
              GCO_ENABLED = "0";
            };
          }); };
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
      #Neovim

      # Extra Utils
      "bin/sessionizer".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/nix-confs/home/tmoss/sessionizer";
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

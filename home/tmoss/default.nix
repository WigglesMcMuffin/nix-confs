{ config, pkgs, pkgs-stable, ... }: let
  username = "tmoss";
in {

  imports = [
    ./main.nix
    ./zsh.nix
    ./wezterm.nix
  ];

  home = let
    stable = with pkgs-stable; [ ];

    unstable = with pkgs; [ ];
  in {
    packages = stable ++ unstable;
  };
}

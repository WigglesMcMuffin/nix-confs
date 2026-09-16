{ pkgs, pkgs-stable, globals, lib, config, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      layer = "top";

      modles-left = [
        "hyprland/workspace"
      ];

      modules-center = [
        "hyprland/window"
        "clock"
      ];

      modules-right = [
        "privacy"
        "hyprland/submap"
        "tray"
      ];
    };

    style = ''

    '';
  };

  home = let
    dotfiles = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."dotfiles".path;
  in {

    mutableFile = {
      "dotfiles" = {
        url = https://github.com/wigglesmcmuffin/dotfiles.git;
        type = "git";
      };
    };

    file = {
      ".config/hypr/lua".source = "${dotfiles}/hypr/lua";
    };
  };

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = lib.mkDefault null;
    portalPackage = lib.mkDefault null;
    extraConfig = ''
    require("lua.init");
    '';
  };
}

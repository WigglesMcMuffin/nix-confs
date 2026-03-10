{ lib, pkgs, pkgs-stable, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
    ];

  nixpkgs.overlays = [
    (final: prev: {
      clipse = prev.clipse.override rec {
        buildGoModule = arg: pkgs.buildGoModule ({
          pname = "clipse";
          version = "1.2.1";
          src = final.fetchFromGitHub {
            owner = "savedra1";
            repo = "clipse";
            rev = "v1.2.1";
            hash = "sha256-iDMHEhYuxspBYG54WivnVj2GfMxAc5dcrjNxtAMhsck=";
          };
          vendorHash = "sha256-rq+2UhT/kAcYMdla+Z/11ofNv2n4FLvpVgHZDe0HqX4=";
          tags = [ "wayland" ];
          env = {
            GCO_ENABLED = "0";
          };
          meta = {
            description = "Useful clipboard manager TUI for Unix";
            homepage = "https://github.com/savedra1/clipse";
            license = lib.licenses.mit;
            mainProgram = "clipse";
            maintainers = [ lib.maintainers.savedra1 ];
          };
        });
      };
    })
  ];
  home = let
    stable = with pkgs-stable; [

    ];

    unstable = with pkgs; [
      qutebrowser
      rofi
      clipse
      obsidian
      thunar
    ];

  in {
    packages = stable ++ unstable;

    sessionVariables = {
      BROWSER = "qutebrowser";
    };

  };

  services.clipse.enable = true;
}

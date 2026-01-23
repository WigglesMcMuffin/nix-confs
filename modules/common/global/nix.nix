{
  inputs,
  lib,
  ...
}: let

in {
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +6";
    };
  };
}

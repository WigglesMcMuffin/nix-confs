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
      # TODO: Figure out what feels actually correct for this
      options = "--delete-older-than +6";
    };
  };
}

{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: 
let
  currentDir = ./.; # Allow submodules to reference module context
in {
  imports = [
    { _module.args = { inherit currentDir; }; }
    ./hardware-configuration.nix
    ../../modules/common/global
    ../../modules/common/global/bare.nix
    ../../modules/hardware/amd
    ../../modules/hardware/audio/pipewire.nix
    ../../modules/networking/nebula
    ../../modules/display/hyprland
    ../../modules/display/plasma
    ./configuration.nix
  ];
}

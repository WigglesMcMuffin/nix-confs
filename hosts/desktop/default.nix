{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/global
    ../../modules/hardware/amd
    ../../modules/hardware/audio/pipewire.nix
    ../../modules/networking/nebula
    ../../modules/display/hyprland
    ../../modules/display/plasma
    ./configuration.nix
  ];
}

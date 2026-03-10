{ config, pkgs, inputs, ... }: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
  ];

  virtualisation.digitalOceanImage.compressionMethod = "bzip2";

  system.stateVersion = "24.11";
}

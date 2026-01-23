{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lact
  ];

  services.lact.enable = true;
  hardware.amdgpu.overdrive.enable = true;
}

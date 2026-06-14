{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./certs.nix
  ];
  #++ (builtins.attrValues outputs.nixosModules);

  services = {
    # Enable CUPS to print documents.
    printing.enable = lib.mkDefault false;

    earlyoom.enable = lib.mkDefault true;
  };

  fonts.packages = [
    pkgs.nerd-fonts.fantasque-sans-mono
  ];

  environment.systemPackages = with pkgs; [
    wget
    htop
    earlyoom
    ethtool
    util-linux
    iptables
    usbutils
    pciutils
    nerd-fonts.fantasque-sans-mono
  ];
}

{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./certs.nix
  ];
  #++ (builtins.attrValues outputs.nixosModules);

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 60;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  services = {
    # Enable CUPS to print documents.
    printing.enable = false;

    earlyoom.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    htop
    earlyoom
    ethtool
    util-linux
    iptables
    usbutils
    pciutils
  ];
}

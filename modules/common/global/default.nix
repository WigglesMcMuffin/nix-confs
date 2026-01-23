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
  ];
  #++ (builtins.attrValues outputs.nixosModules);

  boot.loader.systemd-boot = {
    enable = true;
    # Figure this out, maybe?
    #windows = {
    #  "nvme0n1p1" = {
    #    title = "Windows 10";
    #    # sudo blkid //check Windows ESP PARTUUID
    #    # reboot to systemd-boot uefi shell and type: map
    #    # find the FS alias match Windows ESP (ex: HD0a66666a2, HD0b, FS1, or BLK7)
    #    efiDeviceHandle = "FS0";
    #    sortKey = "a_windows";
    #  };
    #};
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.systemd-boot.extraEntries."archlinux.conf" = ''
    title Archlinux
    linux /vmlinuz-linux
    initrd /initramfs-linux.img
    options root=PARTUUID="5cf51d81-baed-45ce-a4d0-0143d1e82fd0"
  '';

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

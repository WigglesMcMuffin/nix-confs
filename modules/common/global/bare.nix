{ ... }: {
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 60;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
}

{ lib, ... }:

{
  disko.devices.disk = {
    main = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            priority = 0;
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            priority = 1;
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            priority = 2;
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    storage = {
      device = lib.mkDefault "/dev/sdb";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          root = {
            priority = 2;
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/storage";
            };
          };
        };
      };
    };
  };
}

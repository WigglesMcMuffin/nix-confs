{ config, inputs, pkgs, pkgs-stable, ... }:

{
  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenvhostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "kahu";
    networkmanager.enable = false;
    interfaces.enp45s0u1u2u1 = {
      ipv4.addresses = [{
        address = "10.0.0.123";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp45s0u1u2u1";
    };
    firewall.enable = false;
  };

  virtualisation.docker.enable = true;

  sops = {
    age.sshKeyPaths = [ "/home/tmoss/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.tmoss_pass.neededForUsers = true;
  };

  services = {
    xserver.enable = false;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = false;
    pulseaudio.enable = false;

    k3s = {
      serverAddr = "https://10.192.0.4:6443";
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Fzsq8CZ19p+CQKZkeCCC8mkiaKxAD/hnMSibIDk/RTZR0DCyxzzoZaqUSZ0RXpw+r+aHflplzT9fZIWZzCD3VxyJHm8t1iuZery73AnXxyG1Yuhk5/gfNqgPmoL0F0MYlsndTUjFH0isk8edWZxwM5soZD6RzYZj4cIlPJk4B6mtKs5ef80KzRgqdOFPLck0QXserFmUV+2NZJpCqbgzJlFcd56kSKkHsK8Vv29ktyGZHtXTMyJEvK769vxh9lHJt8gJ5P6JAXHFnBUaBXDBNB9QTfpzOzFwonUaLqqcJlexGvKLzuuKHF5kAzg8E0n4kFBNJvJvKr5MzxXsG+qP tmoss@tmoss-desktop-nixos"
      ];
    };

    tmoss = {
      isNormalUser = true;
      description = "Tipene";
      extraGroups = [ "networkmanager" "wheel" "docker"];
      ignoreShellProgramCheck = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Fzsq8CZ19p+CQKZkeCCC8mkiaKxAD/hnMSibIDk/RTZR0DCyxzzoZaqUSZ0RXpw+r+aHflplzT9fZIWZzCD3VxyJHm8t1iuZery73AnXxyG1Yuhk5/gfNqgPmoL0F0MYlsndTUjFH0isk8edWZxwM5soZD6RzYZj4cIlPJk4B6mtKs5ef80KzRgqdOFPLck0QXserFmUV+2NZJpCqbgzJlFcd56kSKkHsK8Vv29ktyGZHtXTMyJEvK769vxh9lHJt8gJ5P6JAXHFnBUaBXDBNB9QTfpzOzFwonUaLqqcJlexGvKLzuuKHF5kAzg8E0n4kFBNJvJvKr5MzxXsG+qP tmoss@tmoss-desktop-nixos"
      ];
      hashedPasswordFile = config.sops.secrets.tmoss_pass.path;
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.lilex
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
    ];


  environment = let
    stable = with pkgs-stable; [
    ];

    unstable = with pkgs; [
      git
      gawk
      gcc
      nerd-fonts.lilex
      nerd-fonts.meslo-lg
      nerd-fonts.noto
      nerd-fonts.shure-tech-mono
      age
      sops
      libcgroup
      openiscsi
    ];
  in {
    systemPackages = stable ++ unstable;

    variables.EDITOR = "nvim";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

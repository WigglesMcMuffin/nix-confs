{ config, inputs, pkgs, pkgs-stable, ... }:

{
  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenvhostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  networking = {
    hostName = "tui";
    interfaces.enp2s0 = {
      ipv4.addresses = [{
        address = "10.0.0.232";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp2s0";
    };
    firewall.enable = false;
  };

  virtualisation.docker.enable = true;

  #zramSwap.enable = true;

  sops = {
    age.sshKeyPaths = [ "/home/tmoss/.ssh/id_ed-v2" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.tmoss_pass.neededForUsers = true;
  };

  services = {
    xserver.enable = false;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = false;
    pulseaudio.enable = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tmoss = {
    isNormalUser = true;
    description = "Tipene";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.tmoss_pass.path;
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

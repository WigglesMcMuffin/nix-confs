{ config, inputs, pkgs, pkgs-stable, ... }:

{
  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenvhostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  networking = {
    hostName = "kea"; # Define your hostname.
    networkmanager.enable = true;
    firewall.enable = false;
  };

  virtualisation.docker.enable = true;

  zramSwap.enable = true;

  security.rtkit.enable = true;
  security.pki.certificateFiles = [
    ./ca.crt
  ];

  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = false;
    pulseaudio.enable = false;

    # Configure keymap in X11
    xserver = {
      # Disable the X11 windowing system.
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    #yubikey
    pcscd.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tmoss = {
    isNormalUser = true;
    description = "Tipene";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  fonts.packages = [
    pkgs.nerd-fonts.lilex
  ];

  programs = {
    # Install firefox.
    firefox.enable = true;

    # STEAM
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "discord"
    ];

    environment = let
      stable = with pkgs-stable; [

      ];

      unstable = with pkgs; [
        git
        gh
        gawk
        signal-desktop-bin
        zathura
        bitwarden-desktop
        obsidian
        gcc
        gimp
        nerd-fonts.lilex
        nerd-fonts.meslo-lg
        nerd-fonts.noto
        nerd-fonts.shure-tech-mono
        libcgroup
        discord
        steamtinkerlaunch
        clipse
      ];
    in {
      systemPackages = stable ++ unstable;
      variables.EDITOR = "nvim";
      etc = {
        "nebula/ca.crt".source = ./nebula.ca.crt;
        "nebula/host.crt".source = ./tmoss.personal.desktop.crt;
        "nebula/host.key".source = ./tmoss.personal.desktop.key;
      };
    };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

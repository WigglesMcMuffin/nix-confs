{ config, inputs, pkgs, pkgs-stable, ... }:

{
  zramSwap.enable = true;

  sops = {
    age.sshKeyPaths = [ "/home/tmoss/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.tmoss_pass.neededForUsers = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    tmoss = {
      isNormalUser = true;
      description = "Tipene";
      extraGroups = [ "networkmanager" "wheel" "docker"];
      ignoreShellProgramCheck = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Fzsq8CZ19p+CQKZkeCCC8mkiaKxAD/hnMSibIDk/RTZR0DCyxzzoZaqUSZ0RXpw+r+aHflplzT9fZIWZzCD3VxyJHm8t1iuZery73AnXxyG1Yuhk5/gfNqgPmoL0F0MYlsndTUjFH0isk8edWZxwM5soZD6RzYZj4cIlPJk4B6mtKs5ef80KzRgqdOFPLck0QXserFmUV+2NZJpCqbgzJlFcd56kSKkHsK8Vv29ktyGZHtXTMyJEvK769vxh9lHJt8gJ5P6JAXHFnBUaBXDBNB9QTfpzOzFwonUaLqqcJlexGvKLzuuKHF5kAzg8E0n4kFBNJvJvKr5MzxXsG+qP tmoss@tmoss-desktop-nixos"
      ];
      #hashedPasswordFile = config.sops.secrets.tmoss_pass.path;
    };
  };

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
    ];
  in {
    systemPackages = stable ++ unstable;

    variables.EDITOR = "nvim";
  };

  system.stateVersion = "24.11";
}

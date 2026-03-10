{ config, inputs, pkgs, pkgs-stable, ... }:

{
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    }
  }

  zramSwap.enable = true;
  
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

  system.stateVersion = "24.11";
}

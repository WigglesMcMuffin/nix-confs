{
  pkgs,
  ...
}: {
  imports = [
    ../../common/optional/wayland.nix
  ];

  programs = {
    niri.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alacritty
  ];
}


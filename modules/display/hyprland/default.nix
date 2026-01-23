{
  pkgs,
  ...
}: {
  imports = [
    ../../common/optional/wayland.nix
  ];

  programs = {
    hyprland.enable = true;
    hyprland.xwayland.enable = false;
  };

  environment.systemPackages = with pkgs; [
    waybar
    swaynotificationcenter
    grim
    slurp
  ];
}

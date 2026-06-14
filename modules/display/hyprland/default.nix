{
  pkgs,
  ...
}: {
  imports = [
    ../../common/optional/wayland.nix
  ];

  programs = {
    uwsm.enable              = true;
    hyprland.enable          = true;
    hyprland.withUWSM        = true;
    hyprland.xwayland.enable = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; [
      waybar
      swaynotificationcenter
      grim
      slurp
      satty
    ];
  };
}

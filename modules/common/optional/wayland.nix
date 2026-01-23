{
  pkgs, ...
}: {
  environment.systemPackages = [
    pkgs.wl-clipboard
  ];

  services = {
    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };
}

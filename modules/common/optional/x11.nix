{
  ...
}: {
  services = {
    # Disable the X11 windowing system.
    xserver.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}

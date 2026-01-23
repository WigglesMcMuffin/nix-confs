{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kubectl
    cilium-cli
    istioctl
  ];
}

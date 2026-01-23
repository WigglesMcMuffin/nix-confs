{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/global
    ./configuration.nix
    ../../modules/common/optional/kubernetes-operator.nix
    #../common/optional/kubernetes-master.nix
  ];
}

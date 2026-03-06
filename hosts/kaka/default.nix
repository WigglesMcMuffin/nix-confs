{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: 
let
  currentDir = ./.; # Allow submodules to reference module context
in {
  imports = [
    { _module.args = { inherit currentDir; }; }
    ./hardware-configuration.nix
    ./disk-layout.nix
    ./configuration.nix
    ../../modules/common/global
    ../../modules/common/global/network.nix
    ../../modules/common/optional/kubernetes-operator.nix
    ../../modules/common/optional/laptop.nix
    ../../modules/common/optional/k8s
    ../../modules/networking/nebula
  ];
}

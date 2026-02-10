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
    ../../modules/common/global
    ../../modules/common/global/network.nix
    ./configuration.nix
    ../../modules/common/optional/kubernetes-operator.nix
    ../../modules/networking/nebula
    ../../modules/common/optional/k8s
    ../../modules/common/optional/k8s/cluster-init.nix
    #../common/optional/kubernetes-master.nix
  ];
}

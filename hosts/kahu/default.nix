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
    ../../modules/common/optional/kubernetes-operator.nix
    ../../modules/networking/nebula
  ];
}

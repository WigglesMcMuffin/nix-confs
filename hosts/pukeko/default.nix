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
    ../../modules/common/global
    ./configuration.nix
    #../../modules/networking/nebula
  ];
}


{
  inputs,
  ...
}: 
let
  currentDir = ./.; # Allow submodules to reference module context
in {
  imports = [
    { _module.args = { inherit currentDir; }; }
    ./configuration.nix
    ../../modules/common/global
  ];
}


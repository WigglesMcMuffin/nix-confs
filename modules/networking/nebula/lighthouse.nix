{ ... }:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  services = {
    nebula.networks.homelab = {
      isLighthouse = true;
      isRelay = true;
      listen = {
        host = "0.0.0.0";
        port = 4242;
      };
      lighthouse.dns = {
        enable = true;
        port = 53;
      };
    };
  };
}


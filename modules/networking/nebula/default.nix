{ pkgs, ... }:

{
  services = {
    nebula.networks.homelab = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      isLighthouse = false;
      lighthouses = [ "10.192.0.1" ];
      relays = [ "10.192.0.1" ];
      staticHostMap = {
        "10.192.0.1" = [ "34.201.63.209:4242" ];
      };
      settings = {
        lighthouse.remote_allow_list = {
          "0.0.0.0/0" = true;
          "10.192.0.0/10" = true;
        };
        firewall.outbound_action = "reject";
        firewall.inbound_action = "reject";

        logging.level = "debug";
        logging.format = "text";

        punchy.punch = true;
      };
      firewall = {
        inbound = [
          {
            host = "any";
            port = "any";
            proto = "icmp";
          }
          {
            host = "any";
            port = "any";
            proto = "any";
          }
        ];
        outbound = [
          {
            host = "any";
            port = "any";
            proto = "any";
          }
        ];
      };
    };
  };

  environment.systemPackages = [
    pkgs.nebula
  ];
}

{ pkgs, lib, currentDir, ... }:

{
  sops = {
    secrets = {
      "host.crt" = {
        path = "/etc/nebula/host.crt";
        sopsFile = (currentDir + "/secrets/nebula.yaml");
        mode = "0440";
        group = "nebula-homelab";
        restartUnits = [ "nebula@homelab.service" ];
      };
      "host.key" = {
        path = "/etc/nebula/host.key";
        sopsFile = (currentDir + "/secrets/nebula.yaml");
        mode = "0440";
        group = "nebula-homelab";
        restartUnits = [ "nebula@homelab.service" ];
      };
    };
  };

  services = {
    nebula.networks.homelab = {
      enable = true;
      ca = "/etc/nebula/ca.crt";
      cert = "/etc/nebula/host.crt";
      key = "/etc/nebula/host.key";
      isLighthouse = lib.mkDefault false;
      lighthouses = [ "10.246.0.1" "10.246.0.2" ];
      relays = [ "10.246.0.1" "10.246.0.2" ];
      staticHostMap = {
        "10.246.0.1" = [ "98.95.163.133:4242" ];
        "10.246.0.2" = [ "159.203.145.200:4242" ];
      };
      settings = {
        lighthouse.remote_allow_list = {
          "0.0.0.0/0" = true;
          "10.246.0.0/15" = true;
        };
        firewall.outbound_action = "reject";
        firewall.inbound_action = "reject";

        logging.level = "info";
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

  environment = {
    etc = {
      "nebula/ca.crt".source = ./nebula.ca.crt;
    };
    systemPackages = [
      pkgs.nebula
    ];
  };
}

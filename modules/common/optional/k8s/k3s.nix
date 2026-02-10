{ 
  config,
  lib, 
  pkgs-stable, 
  ... 
}:

{
  sops = {
    secrets = {
      "cluster_token" = {
        sopsFile = ./secret.yaml;
        mode = "0440";
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        6443
        2379
        2380
      ];

      allowedUDPPorts = [
        8472
      ];
    };
  };

  services = {
    k3s = {
      enable = lib.mkDefault true;

      role = lib.mkDefault "agent";

      tokenFile = config.sops.secrets.cluster_token.path;

      clusterInit = lib.mkDefault false;

      extraFlags = [ "--resolv-conf /etc/kubernetes/resolv.conf" "--kubelet-arg=read-only-port=10255" ];
      extraKubeletConfig = {
        readOnlyPort = 10255;
      };
    };

    etcd = {
      enable = false;
      package = pkgs-stable.etcd;
    };

    openiscsi = {
      enable = true;
      name = "k8s-longhorn";
    };
  };
  
  environment.etc = {
    "kubernetes/resolv.conf".source = ./k8s.resolv.conf;
  };

  systemd.services.iscsid.serviceConfig = {
    PrivateMounts = "yes";
    BindPaths = "/run/current-system/sw/bin:/bin";
  };
}

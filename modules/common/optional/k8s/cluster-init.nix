{ config, pkgs, ... }:

{
  sops = {
    secrets = {
      rdc_key = {
        sopsFile = ./secret.yaml;
      };
      wigglesmcmuffin_key = {
        sopsFile = ./secret.yaml;
      };
    };
    templates = {
      #rdc-creds = {
      #  content = (pkgs.formats.yaml { }).generate "something1" {
      #    apiVersion = "v1";
      #    kind = "Secret";
      #    metadata = {
      #      name = "rdc-argo-ssh";
      #      namespace = "argocd";
      #      labels = {
      #        "argocd.argoproj.io/secret-type" = "repo-creds";
      #      };
      #      stringData.url = "ssh://git@github.com/rubber-ducker-chainsaws/";
      #      stringData.sshPrivateKey = config.sops.placeholder.rdc_key;
      #      strignData.insecure = "true";
      #      stringData.enableLfs = "false";
      #    };
      #  };
      #  path = "/var/lib/rancher/k3s/server/manifests/rdc-creds.json";
      #};
      #wigglesmcmuffin-creds = {
      #  content = (pkgs.formats.yaml { }).generate "something2" {
      #    apiVersion = "v1";
      #    kind = "Secret";
      #    metadata = {
      #      name = "wiggles-argo-ssh";
      #      namespace = "argocd";
      #      labels = {
      #        "argocd.argoproj.io/secret-type" = "repo-creds";
      #      };
      #      stringData.url = "ssh://git@github.com/WigglesMcMuffin/";
      #      stringData.sshPrivateKey = config.sops.placeholder.wigglesmcmuffin_key;
      #      strignData.insecure = "true";
      #      stringData.enableLfs = "false";
      #    };
      #  };
      #  path = "/var/lib/rancher/k3s/server/manifests/wigglesmcmuffin-creds.json";
      #};
    };
  };

  services.k3s = {
    role = "server";
    clusterInit = true;
    extraFlags = [ "--resolv-conf /etc/kubernetes/resolv.conf" "--disable=traefik" "--kubelet-arg=read-only-port=10255" ];
    
    manifests.argo.content = {
      apiVersion = "v1";
      kind = "Namespace";
      metadata.name = "argocd";
    };
  };
}


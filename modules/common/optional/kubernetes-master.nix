{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kubernetes
    containerd
    runc
    cni
    cni-plugins
  ];

  networking.enableIPv6 = false;

  services = {
    kubernetes = {
      roles = ["master"];
      masterAddress = "10.192.0.4";
      apiserverAddress = "https://10.192.0.4:6443";
      easyCerts = true;
      apiserver = {
        securePort = 6443;
        advertiseAddress = "10.192.0.4";
      };

      addons.dns.enable = true;
    };
  };
}

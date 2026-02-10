{ ... }:

{
  networking = {
    networkmanager.enable = false;
    defaultGateway = {
      address = "10.0.0.1";
    };
    firewall.enable = false;
    nameservers = [
      "9.9.9.9"
      "1.1.1.2"
      "8.8.8.8"
      "75.75.75.75"
    ];
  };
}

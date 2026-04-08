{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.haproxy = {
    enable = true;
    config = ''
      frontend http-https-in
      bind *:80
      bind *:443

      use_backend istio-gateway-http if !{ ssl_fc }
      use_backend istio-gateway-https if { ssl_fc }

      backend istio-gateway-http
        mode tcp
        balance roundrobin
        server node1 10.246.8.1:80 check
        server node2 10.246.8.2:80 check
        server node3 10.246.8.3:80 check

      backend istio-gateway-https
        mode tcp
        balance roundrobin
        server node1 10.246.8.1:443 check
        server node2 10.246.8.2:443 check
        server node3 10.246.8.3:443 check
    '';
  };
}

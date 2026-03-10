{ ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.traefik = {
    enable = true;

    dynamicConfigOptions = {
      http = {
        routers = {
          dashboard = {
            rule = "Host(`traefik.10.192.0.10.nip.io`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
            service = "api@internal";
          };
          pub-dashboard = {
            rule = "Host(`traefik.159.203.145.200.nip.io`)";
            service = "api@internal";
          };
          neb-dashboard = {
            rule = "Host(`10.192.0.10`)";
            service = "api@internal";
          };
        };
      };
    };

    staticConfigOptions = {
      api = { 
        dashboard = true;
      };
      entryPoints = {
        web = {
          address = ":80";
          #http = {
          #  redirections = {
          #    entryPoint = {
          #      to = "websecure";
          #      scheme = "https";
          #      permanent = true;
          #    };
          #  };
          #};
        };
        websecure = {
          address = ":443";
        };
      };
      providers = {
        kubernetesingress = {
          endpoint = "https://10.192.0.4:6443";
          certauthfilepath = "";
        };
      };
    };
  };
}

#entryPoints:
#  web:
#    address: ":{{ env "NOMAD_PORT_http" }}"
#    http:
#      redirections:
#        entryPoint:
#          to: websecure
#          scheme: https
#          permanent: true
#    forwardedHeaders:
#      trustedIPs: "{{ env "NOMAD_IP_http" }}"
#    proxyProtocol:
#      trustedIPs: "{{ env "NOMAD_IP_http" }}"
#    observability:
#      accessLogs: true
#      tracing: true
#      metrics: true
#  websecure:
#    asDefault: true
#    address: ":{{ env "NOMAD_PORT_https" }}"
#    proxyProtocol:
#      trustedIPs: "{{ env "NOMAD_IP_https" }}"
#    observability:
#      accessLogs: true
#      tracing: true
#      metrics: true
#  metrics:
#    address: ":{{ env "NOMAD_PORT_metrics" }}"
#  traefik:
#    address: ":{{ env "NOMAD_PORT_api" }}"
##  ts:
##    address: ":9987/udp"
##  minecraft:
##    address: ":25565"
##  terraria:
##    address: ":{{ env "NOMAD_PORT_terraria" }}"
##    forwardedHeaders:
##      trustedIPs: "{{ env "NOMAD_IP_terraria" }}"
##    proxyProtocol:
##      trustedIPs: "{{ env "NOMAD_IP_terraria" }}"
##  satisfactory:
##    address: ":7777/udp"
##  pz:
##    address: ":16261/udp"
#providers:
#  consulcatalog:
#          connectAware: true
#          connectByDefault: false
#          exposedByDefault: true
#          prefix: traefik
#          endpoint:
#            address: "http://nomad.nodes.tipene.dev:8500"
#            scheme: http
#  file:
#    filename: "/etc/traefik/k8s-forwarding.yml"
#    watch: true
#  nomad:
#    endpoint:
#      address: "http://nomad.nodes.tipene.dev:4646"
#certificatesResolvers:
#  myresolver:
#    acme:
#      email: "teee.moose@gmail.com"
#      storage: "/acme/acme.json"
#      httpchallenge:
#        entrypoint: web
#  mystaticresolver:
#    acme:
#      email: "teee.moose@gmail.com"
#      storage: "/acme/acme.static.json"
#      httpchallenge:
#        entrypoint: web
#experimental:
#  plugins:
#    fail2ban:
#      modulename: "github.com/tomMoulard/fail2ban"
#      version: "v0.8.1"
#api:
#  dashboard: true
#  insecure: true
#  debug: true
#ping: {}
#log:
#  level: info
#accessLog: {}
#tracing: {}
#metrics:
#  prometheus:
#    entrypoint: metrics

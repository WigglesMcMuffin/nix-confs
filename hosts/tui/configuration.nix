{ config, inputs, pkgs, pkgs-stable, ... }:

let
  stable = with pkgs-stable; [
    #pkgs-stable.kubernetes
    #pkgs-stable.containerd
    #pkgs-stable.runc
    #pkgs-stable.cni
    #pkgs-stable.cni-plugins
  ];

  unstable = with pkgs; [
    git
    wget
    htop
    gawk
    gcc
    nerd-fonts.lilex
    nerd-fonts.meslo-lg
    nerd-fonts.noto
    nerd-fonts.shure-tech-mono
    nebula
    ethtool
    util-linux
    earlyoom
    iptables
    age
    sops
    libcgroup
    openiscsi
  ];
in {
  _module.args.pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenvhostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  networking = {
    hostName = "tui";
    networkmanager.enable = false;
    interfaces.enp2s0 = {
      ipv4.addresses = [{
        address = "10.0.0.232";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "enp2s0";
    };
  };

  #zramSwap.enable = true;

  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = false;
    pulseaudio.enable = false;

    openiscsi = {
      enable = true;
      name = "k8s-longhorn";
    };

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    xserver.windowManager.awesome.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = false;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

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
          #{
          #  host = "any";
          #  port = "443";
          #  proto = "tcp";
          #  groups = [
          #    "cloud"
          #    "aws"
          #    "tmoss"
          #  ];
          #}
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tmoss = {
    isNormalUser = true;
    description = "Tipene";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  fonts.packages = [
    pkgs.nerd-fonts.lilex
  ];

  # Install firefox.
  programs.firefox.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = stable ++ unstable;

  environment.variables.EDITOR = "nvim";

  environment.etc = {
    "nebula/ca.crt".source = ./nebula.ca.crt;
    "nebula/host.crt".source = ./tmoss.k8s.mini.crt;
    "nebula/host.key".source = ./tmoss.k8s.mini.key;
    "kubernetes/resolv.conf".source = ./k8s.resolv.conf;
  };

  systemd.services.iscsid.serviceConfig = {
    PrivateMounts = "yes";
    BindPaths = "/run/current-system/sw/bin:/bin";
  };

#  systemd.services.kubelet = {
#    enable = true;
#    path = with pkgs; [ kubernetes util-linux containerd cni cni-plugins etcd_3_4 kubectl ];
#
#    documentation = [ "https://kubernetes.io/docs/" ];
#    wants = [ "network-online.target" "containerd.service" ];
#    after = [ "network-online.target" "containerd.service" ];
#    wantedBy = [ "multi-user.target" ];
#
#    serviceConfig = {
#      ExecStart = "/usr/bin/env kubelet --config /etc/kubernetes/kubelet.yaml --v=9";
#      Restart = "always";
#      RestartSec = 10;
#      StartLimitInterval = 0;
#    };
#  };

  #systemd.services.containerd = {
    #enable = true;
    #path = [ pkgs.containerd ];
#
    #documentation = [ "https://containerd.io" ];
    #after = [ "network.target" "dbus.service" ];
    #wantedBy = [ "multi-user.target" ];
#
    #serviceConfig = {
      #ExecStart = "/usr/bin/env containerd";
#
      #Type = "notify";
      #Delegate = "yes";
      #KillMode = "process";
      #Restart = "always";
#
      #LimitNPROC = "infinity";
      #LimitCORE = "infinity";
#
      #TasksMax = "infinity";
      #OOMScoreAdjust = "-999";
    #};
  #};

  services.k3s = {
    enable = true;
    role = "server";
    token = "highly_secret";
    clusterInit = true;
    extraFlags = [ "--resolv-conf /etc/kubernetes/resolv.conf" "--disable=traefik" "--kubelet-arg=read-only-port=10255"];
    extraKubeletConfig = {
      readOnlyPort = 10255;
    };
  };


  services.etcd = {
    enable = false;
    package = pkgs-stable.etcd;
  };

  #services.kubernetes = let
  #  api = "https://10.192.0.4:6443";
  #in
  #{
  #  package = pkgs-stable.kubernetes;
  #  roles = ["master" "node"];
  #  masterAddress = "10.192.0.4";
  #  easyCerts = true;

  #  flannel.enable = false;

  #  apiserverAddress = api;
  #  apiserver = {
  #    enabled = true;
  #    securePort = 6443;
  #    advertiseAddress = "10.192.0.4";
  #  };

  #  addons.dns.enable = true;
  #  kubelet = {
  #    verbosity = 4;
  #    kubeconfig.server = api;
  #    cni = {
  #    	packages = [ pkgs.cilium-cli ];
  #      config = [
  #        {
  #          cniVersion = "0.3.1";
  #          type = "bridge";
  #          name =  "cilium";
  #          plugins = [
  #            {
  #               type = "cilium-cni";
  #               enable-debug = true;
  #               log-file =  "/var/run/cilium/cilium-cni.log";
  #            }
  #          ];
  #        }
  #      ];
  #    };
  #    clusterDns = [ "10.96.0.10" ];
  #    nodeIp = "10.192.0.4";
  #    extraOpts = "--fail-swap-on=false";
  #  };
  #};

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

{
  config,
  lib,
  ...
}:

{

  sops.secrets.easytier_network_secret = { };

  sops.templates."easytier-env" = {
    content = lib.generators.toKeyValue { } {
      ET_NETWORK_NAME = "feccc-net";
      ET_NETWORK_SECRET = config.sops.placeholder.easytier_network_secret;
    };
  };

  services.easytier = {
    enable = true;
    instances.default = {
      environmentFiles = [
        config.sops.templates."easytier-env".path
      ];

      settings = {
        hostname = config.networking.hostName;
        dhcp = true;
        listeners = [
          "tcp://0.0.0.0:11010"
          "udp://0.0.0.0:11010"
          "wg://0.0.0.0:11011"
          "wss://0.0.0.0:11012"
        ];
        peers = [
          "udp://192.168.0.10:11010"
          "tcp://47.243.180.98:11010"
          "udp://47.243.180.98:11010"
        ];
      };
      extraSettings = {
        flags = {
          private_mode = true;
        };
      };
      extraArgs = [ "--secure-mode" ];
    };
  };

  # ---- firewall ----
  networking.firewall.allowedTCPPorts = [
    11010
    11011
    11012
  ];
  networking.firewall.allowedUDPPorts = [
    11010
    11011
  ];
}

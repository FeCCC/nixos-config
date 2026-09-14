{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.my_config.tor = {
    enable = lib.mkEnableOption "use tor" // {
      default = true;
    };
  };

  config = lib.mkIf config.my_config.tor.enable {
    containers.tor = {
      autoStart = true;
      config =
        { ... }:
        {
          networking = {
            firewall = {
              allowedTCPPorts = [
                9050
              ];
              allowedUDPPorts = [
                9050
              ];
            };
          };
          services = {
            tor = {
              enable = true;
              client.enable = true;
              settings = {
                UseBridges = false;
                ClientTransportPlugin = "obfs4,webtunnel exec ${pkgs.obfs4}/bin/lyrebird";
                ClientUseIPv4 = true;
                ClientUseIPv6 = true;
                Bridge = [
                  # bridges
                ];
              };
            };
          };
          system.stateVersion = "24.11";
        };
    };
  };
}

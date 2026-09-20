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
    services.tor = {
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
}

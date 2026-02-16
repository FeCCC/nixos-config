{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my_config.netdata = {
    enable = lib.mkEnableOption "use docker";
  };
  config = lib.mkIf config.my_config.netdata.enable {
    networking.firewall.allowedTCPPorts = [ 19999 ];
    services.netdata = {
      enable = true;
      package = pkgs.netdataCloud;
      config = {
        db = {
          "enable replication" = "yes";
          "replication period" = "1d";
          "update every" = "1s";
          "db" = "dbengine";
          "dbengine page cache size" = "1.4GiB";
          "storage tiers" = "3";
          "dbengine tier backfill" = "new";
          "dbengine tier 1 update every iterations" = "60";
          "dbengine tier 2 update every iterations" = "60";
          "dbengine tier 0 retention size" = "12GiB";
          "dbengine tier 1 retention size" = "4GiB";
          "dbengine tier 2 retention size" = "2GiB";
        };
      };
      configDir."stream.conf" = pkgs.writeText "stream.conf" ''
        [stream]
        enabled = no
        enable compression = yes

        [netdata-api]
        type = api
        enabled = yes
      '';
    };
  };
}

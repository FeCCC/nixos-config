{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my_config.netdata = {
    enable = lib.mkEnableOption "netdata monitoring agent";
    parentHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Parent netdata host to stream metrics to. null = standalone or parent node.";
    };
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
      configDir."stream.conf" =
        let
          parentHost = config.my_config.netdata.parentHost;
        in
        pkgs.writeText "stream.conf" ''
          [stream]
          enabled = ${if parentHost != null then "yes" else "no"}
          enable compression = yes
          ${
            if parentHost != null then
              ''
                destination = ${parentHost}:19999
                api key = netdata-api
                reconnect delay seconds = 5
                initial clock resync iterations = 60
              ''
            else
              ""
          }
          [netdata-api]
          type = api
          enabled = yes
        '';
    };
  };
}

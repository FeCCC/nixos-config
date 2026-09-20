{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my_config.i2pd = {
    enable = lib.mkEnableOption "use i2pd" // {
      default = false;
    };
  };

  config = lib.mkIf config.my_config.i2pd.enable {
    services.i2pd = {
      enable = true;
      logLevel = "info";
      enableIPv4 = true;
      enableIPv6 = true;
      floodfill = true;
      reseed.verify = true;
      yggdrasil.enable = true;
      proto = {
        http = {
          enable = true;
          port = 7070;
          strictHeaders = false;
        };
        httpProxy = {
          enable = true;
          port = 4444;
          # outproxy = "http://exit.stormycloud.i2p";
          outproxy = "http://outproxy.acetone.i2p";
        };
        socksProxy = {
          enable = true;
          port = 4447;
          outproxyEnable = true;
          outproxy = "localhost";
          outproxyPort = 9050;
        };
        sam = {
          enable = true;
          port = 7656;
        };
        i2cp = {
          enable = true;
          port = 7654;
        };
      };
    };

    # nixpkgs 模块无 extraConfig(#228182)、包也不安装 contrib/certificates,
    # 而 reseed.verify=true 需要它们。switch 时直接铺进 datadir。
    system.activationScripts.i2pd-certs = {
      text = ''
        mkdir -p /var/lib/i2pd/certificates
        cp -r ${pkgs.i2pd.src}/contrib/certificates/. /var/lib/i2pd/certificates/
        chown -R i2pd:i2pd /var/lib/i2pd/certificates
      '';
      deps = [ ];
    };
  };
}

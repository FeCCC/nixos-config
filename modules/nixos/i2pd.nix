{ ... }:
{
  containers.i2pd = {
    autoStart = true;
    config =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [
          7070
          4447
          4444
          7656
          7654
        ];
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
              address = "0.0.0.0";
              port = 7070;
              strictHeaders = false;
            };
            httpProxy = {
              enable = true;
              address = "0.0.0.0";
              port = 4444;
              # outproxy = "http://exit.stormycloud.i2p";
              outproxy = "http://outproxy.acetone.i2p";
            };
            socksProxy = {
              enable = true;
              address = "0.0.0.0";
              port = 4447;
            };
            sam = {
              enable = true;
              address = "0.0.0.0";
              port = 7656;
            };
            i2cp = {
              enable = true;
              address = "0.0.0.0";
              port = 7654;
            };
          };
        };
      };
  };
}

{ ... }:
{
  containers.i2pd = {
    autoStart = true;
    config =
      { ... }:
      {
        networking.firewall = {
          allowedTCPPorts = [
            7070
            4447
            4444
            7656
            7654
          ];
          allowedUDPPorts = [
            7070
            4447
            4444
            7656
            7654
          ];
        };
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
        system.stateVersion = "24.11";
      };
  };
}

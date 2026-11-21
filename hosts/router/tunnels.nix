{ config, lib, ... }:
let
  wgPeers = [
    {
      name = "redmi-k60";
      publicKey = "sh1zcqUQEe2J7NrbSXwVKCXeQRf0Tr28oimiG4t9Knw=";
      allowedIPs = [ "10.12.12.3/32" ];
    }
    {
      name = "gn";
      publicKey = "e7+dhyPW0ZBFppGAbOicqWHF4912m5PenfEjBUoyBGo=";
      allowedIPs = [ "10.12.12.2/32" ];
    }
    {
      name = "daye";
      publicKey = "HoxJLWiAJO046pmqvc8JhIJZbeCeXc1izbCEfNniHhU=";
      allowedIPs = [ "10.12.12.4/32" ];
    }
    {
      name = "thinkbook-x";
      publicKey = "bhrVttrkjUD1Tpe5/MzerBu5/ZQyALCEqZTmEdnWPDM=";
      allowedIPs = [ "10.12.0.0/16" ];
    }
  ];

  frpEnvTemplate = {
    content = ''
      # token 与密码从环境变量注入
      FRP_TOKEN=${config.sops.placeholder.frp_token}
      FRP_ADMIN_PWD=${config.sops.placeholder.frp_admin_pwd}
    '';
  };

  frpCommon = {
    serverAddr = config.my_config.fabric.vps;
    serverPort = 7000;
    loginFailExit = false;
    transport.protocol = "tcp";
    auth = {
      method = "token";
      token = "{{ .Envs.FRP_TOKEN }}";
    };
    log = {
      level = "info";
      maxDays = 7;
      # 关掉颜色输出
      disablePrintColor = true;
    };
    webServer = {
      addr = "0.0.0.0";
      user = "admin";
      password = "{{ .Envs.FRP_ADMIN_PWD }}";
    };
  };
in
{
  # ---------------- WireGuard（内核实现） ----------------
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.12.12.1/16" ];
    listenPort = 51820;
    privateKeyFile = lib.mkDefault config.sops.secrets.wireguard_private_key.path;
    peers = map (p: p // { persistentKeepalive = 25; }) wgPeers;
  };

  sops.secrets.wireguard_private_key = { };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # 把 wg0 当 LAN 成员处理
  networking.firewall.trustedInterfaces = [ "wg0" ];

  services.yggdrasil = {
    enable = true;

    settings = {
      # 共享配置的 peer 列表照抄，只去掉指向自己的那条
      Peers = lib.mkForce [
        "quic://${config.my_config.fabric.vps}:7777"
        "tls://ygg-tw.lxak.net:443"
        "tls://cowgl.tech:1337"
        "tls://ygg5.mk16.de:1338?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
        "tcp://pp1.ygg.sy.sa:8441"
        "tls://ygg.ace.ctrl-c.liu.se:9999?key=5636b3af4738c3998284c4805d91209cab38921159c66a6f359f3f692af1c908"
        "tls://yg-tyo.magicum.net:32333"
        "tls://asia.deinfra.org:15015"
        "tls://mn.us.ygg.triplebit.org:993"
      ];

      # 共享配置不自带监听，这里对外收对端
      Listen = lib.mkForce [ "tls://[::]:7777" ];
    };
  };

  services.easytier = {
    enable = true;
    instances.default = {
      settings = {
        hostname = lib.mkForce config.networking.hostName;
        ipv4 = lib.mkForce "10.126.126.2/24";
        dhcp = lib.mkForce false;
        listeners = lib.mkForce [
          "tcp://0.0.0.0:11010"
          "udp://0.0.0.0:11010"
          "tcp://0.0.0.0:44395"
        ];
        peers = lib.mkForce [
          "tcp://${config.my_config.fabric.vps}:11010"
          "udp://${config.my_config.fabric.vps}:11010"
        ];
      };
      extraSettings = lib.mkForce {
        flags = {
          private_mode = true;
          # 钉住 TUN 设备名
          dev_name = "tun0";
        };
      };
      # 避免重复传 flag
      extraArgs = lib.mkForce [ "--secure-mode" ];
    };
  };

  # ---------------- frp ----------------
  sops.secrets.frp_token = { };
  sops.secrets.frp_admin_pwd = { };
  sops.templates."frp-env" = frpEnvTemplate;

  services.frp.instances = {
    wireguard = {
      enable = true;
      role = "client";
      environmentFiles = [ config.sops.templates."frp-env".path ];
      settings = frpCommon // {
        webServer = frpCommon.webServer // {
          port = 7401;
        };
        # 给 WireGuard 打洞
        proxies = [
          {
            name = "wireguard";
            type = "udp";
            localPort = 51820;
            remotePort = 51820;
            transport.useEncryption = true;
            transport.useCompression = true;
          }
        ];
      };
    };

    misc = {
      enable = true;
      role = "client";
      environmentFiles = [ config.sops.templates."frp-env".path ];
      settings = frpCommon // {
        webServer = frpCommon.webServer // {
          port = 7400;
        };
      };
    };
  };

  networking.firewall.interfaces.br-lan = {
    allowedTCPPorts = [
      7777
      11010
      15888
      44395
    ];
    allowedUDPPorts = [ 11010 ];
  };
}

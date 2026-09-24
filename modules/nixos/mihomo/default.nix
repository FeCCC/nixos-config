{
  config,
  lib,
  pkgs,
  ...
}:
let
  mihomo-config = import ./config.nix;
in
{
  options.my_config.mihomo.enable = lib.mkEnableOption "enable mihomo TUN proxy";

  options.my_config.mihomo.tunStack = lib.mkOption {
    type = lib.types.enum [
      "gvisor"
      "system"
    ];
    default = "system";
  };

  config = lib.mkIf config.my_config.mihomo.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.unstable.mihomo;
      tunMode = true;
      webui = pkgs.zashboard;
      configFile = config.sops.templates."mihomo-config".path;
    };

    sops.templates.mihomo-config.content = builtins.readFile (
      (pkgs.formats.yaml { }).generate "mihomo-config.yaml" (
        mihomo-config
        // {
          tun = mihomo-config.tun // {
            stack = config.my_config.mihomo.tunStack;
          };
        }
      )
    );
  };
}

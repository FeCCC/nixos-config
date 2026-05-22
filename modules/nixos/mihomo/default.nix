{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my_config.mihomo.enable = lib.mkEnableOption "enable mihomo TUN proxy";

  config = lib.mkIf config.my_config.mihomo.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.unstable.mihomo;
      tunMode = true;
      webui = pkgs.zashboard;
      configFile = config.sops.templates."mihomo-config".path;
    };

    sops.templates.mihomo-config.content = builtins.readFile (
      (pkgs.formats.yaml { }).generate "mihomo-config.yaml" (import ./config.nix)
    );

  };
}

{
  pkgs,
  config,
  ...
}:
{
  home.packages = [ pkgs.unstable.codex ];
  home.sessionVariables.CODEX_HOME = "${config.xdg.configHome}/codex";
  sops.secrets.codex_config = {
    path = "${config.xdg.configHome}/codex/config.toml";
  };
  sops.secrets.codex_api_key = {
    path = "${config.xdg.configHome}/codex/.env";
  };
}

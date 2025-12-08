{
  pkgs,
  config,
  ...
}:
{
  programs.claude-code.enable = true;
  sops.secrets.claude_code_settings = {
    path = "${config.home.homeDirectory}/.claude/settings.json";
  };
}

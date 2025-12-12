{
  pkgs,
  config,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
  };
  home.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  sops.secrets.new_api_base_url_for_anthropic = { };
  sops.templates.claude_code_settings = {
    path = "${config.xdg.configHome}/claude/settings.json";
    content = ''
      {
          "env": {
              "ANTHROPIC_BASE_URL": "${config.sops.placeholder.new_api_base_url_for_anthropic}",
              "ANTHROPIC_MODEL": "deepseek/deepseek-v3.2",
              "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
          },
          "apiKeyHelper": "echo '${config.sops.placeholder.new_api_key}'"
      }
    '';
  };
}

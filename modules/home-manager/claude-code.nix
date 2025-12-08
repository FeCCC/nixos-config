{
  pkgs,
  config,
  ...
}:
{
  programs.claude-code.enable = true;
  sops.templates.claude_code_settings = {
    path = "${config.home.homeDirectory}/.claude/settings.json";
    content = ''
      {
          "env": {
              "ANTHROPIC_BASE_URL": "${config.sops.placeholder.new_api_base_url}",
              "ANTHROPIC_MODEL": "deepseek/deepseek-v3.2",
              "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
          },
          "apiKeyHelper": "echo '${config.sops.placeholder.new_api_key}'"
      }
    '';
  };
}

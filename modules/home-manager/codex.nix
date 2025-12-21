{
  pkgs,
  config,
  ...
}:
{
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex;
  };
  home.sessionVariables.CODEX_HOME = "${config.xdg.configHome}/codex";
  sops.secrets.new_api_base_url_for_openai = { };
  sops.secrets.new_api_key = { };
  sops.templates.codex_config = {
    path = "${config.xdg.configHome}/codex/config.toml";
    content = ''
      # Recall that in TOML, root keys must be listed before tables.
      model = "deepseek/deepseek-v3.2"
      # model = "google/gemini-2.5-flash"
      model_provider = "new-api"
      model_context_window = 163840
      # model_context_window = 1048576
      approval_policy = "on-request"

      [model_providers.new-api]
      name = "New Api"
      base_url = "${config.sops.placeholder.new_api_base_url_for_openai}"
      env_key = "NEWAPI_API_KEY"
      # Valid values for wire_api are "chat" and "responses". Defaults to "chat" if omitted.
      wire_api = "chat"

      [features]
      web_search_request = true
    '';
  };
  sops.templates.codex_api_key = {
    path = "${config.xdg.configHome}/codex/.env";
    content = "NEWAPI_API_KEY=${config.sops.placeholder.new_api_key}";
  };
}

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
      model = "google/gemini-2.5-pro"
      #model = "openai/gpt-5-codex"
      model_provider = "new-api"
      model_context_window = 1048576

      [model_providers.new-api]
      # Name of the provider that will be displayed in the Codex UI.
      name = "New Api"
      # The path `/chat/completions` will be amended to this URL to make the POST
      # request for the chat completions.
      base_url = "${config.sops.placeholder.new_api_base_url_for_openai}"
      # If `env_key` is set, identifies an environment variable that must be set when
      # using Codex with this provider. The value of the environment variable must be
      # non-empty and will be used in the `Bearer TOKEN` HTTP header for the POST request.
      env_key = "NEWAPI_API_KEY"
      # Valid values for wire_api are "chat" and "responses". Defaults to "chat" if omitted.
      wire_api = "chat"
      # The model decides when to escalate
      approval_policy = "on-request"

      [features]
      web_search_request = true
    '';
  };
  sops.templates.codex_api_key = {
    path = "${config.xdg.configHome}/codex/.env";
    content = "NEWAPI_API_KEY=${config.sops.placeholder.new_api_key}";
  };
}

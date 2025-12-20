{
  pkgs,
  config,
  ...
}:
{
  programs.gemini-cli = {
    enable = true;
    package = pkgs.unstable.gemini-cli;
    # defaultModel = "gemini-3-flash-preview";
  };

  sops.secrets.new_api_base_url_for_gemini = { };
  sops.secrets.new_api_key = { };
  sops.templates.gemini_env = {
    path = "${config.home.homeDirectory}/.gemini/.env";
    content = ''
      GOOGLE_GEMINI_BASE_URL=${config.sops.placeholder.new_api_base_url_for_openai}
      GEMINI_API_KEY=${config.sops.placeholder.new_api_key}
      GEMINI_MODEL=gemini-3-flash-preview
    '';
  };
  sops.templates.codex_api_key = {
    path = "${config.xdg.configHome}/codex/.env";
    content = "NEWAPI_API_KEY=${config.sops.placeholder.new_api_key}";
  };

}

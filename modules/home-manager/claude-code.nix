{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = [ pkgs.claude-code-router ];
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
  };

  home.sessionVariables.CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
  sops.secrets.new_api_base_url_for_ccr = { };
  sops.templates.claude_code_router_settings = {
    path = "${config.home.homeDirectory}/.claude-code-router/config.json";
    content = ''
      {
        "LOG": false,
        "LOG_LEVEL": "debug",
        "HOST": "127.0.0.1",
        "PORT": 3456,
        "APIKEY": "",
        "API_TIMEOUT_MS": "600000",
        "Providers": [
          {
            "name": "new_api",
            "api_base_url": "${config.sops.placeholder.new_api_base_url_for_ccr}",
            "api_key": "${config.sops.placeholder.new_api_key}",
            "models": [
              "deepseek/deepseek-v3.2",
              "google/gemini-3-pro-preview",
              "google/gemini-2.5-pro",
              "google/gemini-2.5-flash",
              "google/gemini-3-flash-preview",
              "gemini-3-flash-preview",
              "gemini-3-pro-preview"
            ],
            "transformer": {
              "use": []
            }
          }
        ],
        "Router": {
          "default": "new_api,google/gemini-2.5-flash",
          "background": "new_api,google/gemini-2.5-flash",
          "think": "new_api,deepseek/deepseek-v3.2",
          "longContext": "new_api,google/gemini-2.5-flash",
          "longContextThreshold": 60000,
          "webSearch": "",
          "image": ""
        },
      }
    '';
  };
}

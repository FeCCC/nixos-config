{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
  };

  sops.secrets.new_api_base_url_for_openai = { };
  sops.secrets.new_api_key = { };
  sops.templates.opencode_config = {
    path = "${config.xdg.configHome}/opencode/opencode.json";
    content = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "provider": {
          "new-api": {
            "npm": "@ai-sdk/openai-compatible",
            "name": "New API",
            "options": {
              "baseURL": "${config.sops.placeholder.new_api_base_url_for_openai}",
              "apiKey": "${config.sops.placeholder.new_api_key}"
            },
            "models": {
              "deepseek/deepseek-v3.2": {
                "name": "deepseek/deepseek-v3.2",
                "limit": {
                    "context": 163840,
                    "output": 163840
                }
              },
              "google/gemini-3-flash-preview": {
                "name": "google/gemini-3-flash-preview",
                "limit": {
                    "context": 1048576,
                    "output": 1048576
                }
              },
              "google/gemini-2.5-flash": {
                "name": "google/gemini-2.5-flash",
                "limit": {
                    "context": 1048576,
                    "output": 1048576
                }
              },
              "google/gemini-2.5-pro": {
                "name": "google/gemini-2.5-pro",
                "limit": {
                    "context": 1048576,
                    "output": 1048576
                }
              }
            }
          }
        },
        "permission": {
          "edit": "ask",
          "bash": {
            "ls": "allow",
            "grep": "allow",
            "rg": "allow",
            "git status": "allow",
            "git log": "allow",
            "git show": "allow",
            "git diff": "allow",
            "*": "ask"
          }
        }
      }
    '';
  };
}

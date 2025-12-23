{
  lib,
  pkgs,
  config,
  ...
}:
let
  # 安全包裹脚本, 用于在运行时注入密钥
  opencode-wrapped = pkgs.writeShellScriptBin "opencode" ''
    #!${pkgs.runtimeShell}
    # 从 sops-nix 管理的文件中读取密钥并导出为环境变量
    export OPENCODE_API_KEY=$(cat "${config.sops.secrets.new_api_key.path}")
    export OPENCODE_BASE_URL=$(cat "${config.sops.secrets.new_api_base_url_for_openai.path}")

    # 执行真正的 opencode 程序
    exec "${pkgs.unstable.opencode}/bin/opencode" "$@"
  '';
in
{
  programs.opencode = {
    enable = true;
    # 将默认的 opencode 包替换为安全包裹脚本
    package = opencode-wrapped;
  };

  # 定义包裹脚本需要的密钥
  sops.secrets.new_api_base_url_for_openai = { };
  sops.secrets.new_api_key = { };

  # 配置文件本身不包含任何密钥信息
  # 依赖包裹脚本在运行时注入的环境变量
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
              "baseURL": "{env:OPENCODE_BASE_URL}",
              "apiKey": "{env:OPENCODE_API_KEY}"
            },
            "models": {
              "deepseek/deepseek-v3.2": {
                "name": "deepseek/deepseek-v3.2",
                "limit": {
                    "context": 163840,
                    "output": 163840
                }
              },
              "x-ai/grok-4.1-fast": {
                "name": "x-ai/grok-4.1-fast",
                "limit": {
                    "context": 2000000,
                    "output": 2000000
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

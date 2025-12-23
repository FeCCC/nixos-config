{
  lib,
  pkgs,
  config,
  ...
}:
let
  # 一个安全的包裹脚本, 用于在运行时注入密钥
  codex-wrapped = pkgs.writeShellScriptBin "codex" ''
    #!${pkgs.runtimeShell}
    # 从 sops-nix 管理的文件中读取密钥并导出为环境变量
    export NEWAPI_API_KEY=$(cat "${config.sops.secrets.new_api_key.path}")
    # 执行真正的 codex 程序, 并传递所有参数
    exec "${pkgs.unstable.codex}/bin/codex" "$@"
  '';
in
{
  programs.codex = {
    enable = true;
    # 将默认的 codex 包替换为我们的安全包裹脚本
    package = codex-wrapped;
  };

  home.sessionVariables.CODEX_HOME = "${config.xdg.configHome}/codex";

  # 定义包裹脚本需要的密钥
  sops.secrets.new_api_base_url_for_openai = { };
  sops.secrets.new_api_key = { };

  # 这个模板仍然是必需的, 它告诉 codex 从哪个环境变量读取密钥
  sops.templates.codex_config = {
    path = "${config.xdg.configHome}/codex/config.toml";
    content = ''
      model = "deepseek/deepseek-v3.2"
      model_provider = "new-api"
      model_context_window = 163840
      approval_policy = "on-request"

      [model_providers.new-api]
      name = "New Api"
      base_url = "${config.sops.placeholder.new_api_base_url_for_openai}"
      env_key = "NEWAPI_API_KEY"
      wire_api = "chat"

      [features]
      web_search_request = true
    '';
  };
}

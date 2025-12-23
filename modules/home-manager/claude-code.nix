{
  lib,
  pkgs,
  config,
  ...
}:
let
  # 安全的包裹脚本, 用于在运行时注入密钥
  claude-code-wrapped = pkgs.writeShellScriptBin "claude" ''
    #!${pkgs.runtimeShell}
    # 从 sops-nix 管理的文件中读取密钥并导出为环境变量
    export ANTHROPIC_API_KEY=$(cat "${config.sops.secrets.new_api_key.path}")
    export ANTHROPIC_BASE_URL=$(cat "${config.sops.secrets.new_api_base_url_for_claude.path}")
    export ANTHROPIC_MODEL="deepseek/deepseek-v3.2"
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"

    # 执行真正的 claude-code 程序, 并传递所有参数
    exec "${pkgs.unstable.claude-code}/bin/claude" "$@"
  '';
in
{
  programs.claude-code = {
    enable = true;
    # 将默认的 claude-code 包替换为安全包裹脚本
    package = claude-code-wrapped;
  };

  # 定义包裹脚本需要的密钥
  sops.secrets.new_api_base_url_for_claude = { };
  sops.secrets.new_api_key = { };
}

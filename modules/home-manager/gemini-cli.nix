{
  lib,
  pkgs,
  config,
  ...
}:
let
  # 安全包裹脚本, 用于在运行时注入密钥
  gemini-cli-wrapped = pkgs.writeShellScriptBin "gemini" ''
    #!${pkgs.runtimeShell}
    # 从 sops-nix 管理的文件中读取密钥并导出为环境变量
    export GOOGLE_GEMINI_BASE_URL=$(cat "${config.sops.secrets.new_api_base_url_for_gemini.path}")
    export GEMINI_API_KEY=$(cat "${config.sops.secrets.new_api_key.path}")
    export GEMINI_MODEL=gemini-3-flash-preview

    # 执行真正的 gemini-cli 程序, 并传递所有参数
    exec "${pkgs.unstable.gemini-cli}/bin/gemini" "$@"
  '';
in
{
  programs.gemini-cli = {
    enable = true;
    # 将默认的 gemini-cli 包替换为安全包裹脚本
    package = gemini-cli-wrapped;
  };

  # 定义包裹脚本需要的密钥
  sops.secrets.new_api_base_url_for_gemini = { };
  sops.secrets.new_api_key = { };
}

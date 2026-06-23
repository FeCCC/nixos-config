{
  lib,
  pkgs,
  config,
  inputs,
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

  # 构建 agency-agents 的 opencode 版本
  opencode-agency-agents = pkgs.stdenv.mkDerivation {
    name = "opencode-agency-agents";
    src = inputs.agency-agents;

    buildInputs = [ pkgs.bash ];

    buildPhase = ''
      patchShebangs scripts/
      bash scripts/convert.sh --tool opencode
    '';

    installPhase = ''
      mkdir -p $out
      cp -r integrations/opencode/agents/* $out/
    '';
  };

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
    content = builtins.toJSON (import ./config.nix { inherit pkgs inputs; });
  };

  # skills 集成
  xdg.configFile = {
    "opencode/skill" = {
      source = pkgs.symlinkJoin {
        name = "opencode-skills-merged";
        paths = [
          (inputs.superpowers + "/skills")
          (inputs.cc-skills + "/skills")
          (inputs.pua + "/skills")
          (inputs.multi-agent + "/skills")
          (inputs.context-engineering + "/skills")
        ];
      };
      recursive = true;
    };
    "opencode/skill/novel-control-station" = {
      source = inputs.novel-control-station;
      recursive = true;
    };
    "opencode/skill/unsloth-buddy" = {
      source = inputs.unsloth-buddy;
      recursive = true;
    };

    "opencode/agents" = {
      source = opencode-agency-agents;
      recursive = true;
    };
  };
}

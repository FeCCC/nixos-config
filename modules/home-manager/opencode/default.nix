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

  agencyPersonas = inputs.agency-personas.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

  # codebase-memory-mcp 工具
  home.packages = [
    inputs.codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile = {
    # skills 集成
    "opencode/skill" = {
      source = pkgs.symlinkJoin {
        name = "opencode-skills-merged";
        paths = [
          (inputs.superpowers + "/skills")
          (inputs.cc-skills + "/skills")
          (inputs.pua + "/skills")
          agencyPersonas
        ];
      };
      recursive = true;
    };

    # 全局规则：行为纪律 + MCP 工具说明 + opencode 专属段
    # opencode 没有 RULES.md 这类粘性规则机制，行为纪律只能放 AGENTS.md；
    # 前两段与 omp 共用 ../agent-prompts/ 下的源文件，避免两份拷贝漂移
    "opencode/AGENTS.md".text =
      "# 全局规则\n\n## 行为纪律\n\n"
      + builtins.readFile ../agent-prompts/rules.md
      + "\n## 工具：codebase-memory-mcp\n\n"
      + builtins.readFile ../agent-prompts/codebase-memory-mcp.md
      + "\n"
      + builtins.readFile ./codebase-memory-mcp.extra.md;
  };
}

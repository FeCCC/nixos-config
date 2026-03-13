# NixOS 配置仓库

## 项目结构
这是一个基于 Nix flake 的配置仓库，包含:
- 多主机 NixOS 配置
- Home-manager 用户配置
- 可重用的模块和覆盖层
- SOPS 管理的密钥
- 通过 pkgs/ 的自定义包

既可以作为NixOS的配置，也可以在安装了nix的非NixOS主机上作为home-manager配置

### 文件组织
- 主机配置在 `hosts/` 目录，存放与特定主机相关的配置
- Home-manager 模块在 `modules/home-manager/`，在home-manager里有相关配置的尽量放在这里
- NixOS 模块在 `modules/nixos/`，系统相关模块配置放在这里，但同时有home-manager配置的情况下优先放在home-manager下面
- 自定义包在 `pkgs/`
- 覆盖层在 `overlays/`，例如自定义rime配置就放在这里

### 安全性
- 使用 SOPS 管理密钥 (见 `sops.nix`)
- 不要硬编码凭据
- 遵循最小权限原则


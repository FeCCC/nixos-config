# NixOS 配置仓库

## 项目结构
这是一个基于 Nix flake 的配置仓库，包含:
- 多主机 NixOS 配置
- Home-manager 用户配置
- 可重用的模块和覆盖层
- SOPS 管理的密钥
- 通过 pkgs/ 的自定义包

既可以作为NixOS的配置，也可以在安装了nix的非NixOS主机上作为home-manager配置

### 入口与分层
- flake.nix 是总入口，注册 nixosConfigurations 和 homeConfigurations
- nixos/configuration.nix 是所有 NixOS 主机的公共基底（sops、users、home-manager 集成、硬件、磁盘），hosts/ 只放各主机差异
- home-manager/ 是 home 配置入口（miku.nix、wl.nix、root.nix）
- modules/nixos/ 和 modules/home-manager/ 是可复用模块库，flake 分别导出为 nixosModules 和 homeManagerModules
- modules/common/ 存放通用配置（nixpkgs 选项、apps、packs）
- modules/packs/ 存放包组（如 desktop）

### 文件组织
- 主机配置在 `hosts/` 目录，存放与特定主机相关的差异配置，公共配置进 nixos/configuration.nix
- Home-manager 模块在 `modules/home-manager/`，在home-manager里有相关配置的尽量放在这里
- NixOS 模块在 `modules/nixos/`，系统相关模块配置放在这里，但同时有home-manager配置的情况下优先放在home-manager下面
- 自定义包在 `pkgs/`
- 覆盖层在 `overlays/`，例如自定义rime配置就放在这里

### 新增主机/用户
- 新增 NixOS 主机：先在 flake.nix 的 nixosConfigurations 注册，再建 hosts/<主机>/ 目录放差异配置，公共部分写进 nixos/configuration.nix
- 新增 home 用户：先在 flake.nix 的 homeConfigurations 注册，再建 home-manager/<用户>.nix

### 安全性
- 使用 SOPS 管理密钥 (见 `sops.nix`)
- 不要硬编码凭据
- 遵循最小权限原则

# Nix 配置仓库开发指南

## 构建/格式化/测试命令

### 代码格式化
- 格式化所有 Nix 文件: `nix fmt`
- 格式化特定文件: `nixfmt path/to/file.nix`
- 格式化工具: nixfmt-tree (在 flake.nix 中配置)

### 开发环境
- 进入默认 shell: `nix develop`
- 进入特定 shell: `nix develop .#shell-name`
  可用 shell: default, node, rust, gcc48

### 系统管理
- 重建系统: `sudo nixos-rebuild switch --flake .#hostname`
- 更新 home-manager: `home-manager switch --flake .#user`

### Flake 操作
- 显示可用输出: `nix flake show`
- 更新输入: `nix flake update`
- 构建包: `nix build .#package-name`

## 代码风格指南

### Nix 语言约定
- 使用 2 空格缩进
- 遵循 Nixpkgs 函数参数模式
- 使用 `let ... in` 进行局部绑定
- 优先使用属性集而非多个参数

### 文件组织
- 主机配置在 `hosts/` 目录
- Home-manager 模块在 `modules/home-manager/`
- NixOS 模块在 `modules/nixos/`
- 自定义包在 `pkgs/`
- 覆盖层在 `overlays/`

### 命名约定
- 包名使用 snake_case
- 遵循 Nixpkgs 属性命名约定
- 模块和选项使用描述性名称

### 导入模式
- 本地模块使用相对导入
- Flake 输入使用 `inputs`
- 遵循 NixOS 模块系统模式

### 错误处理
- 使用 `assert` 进行验证
- 提供有用的错误信息
- 使用 `lib` 函数进行类型检查

### 安全性
- 使用 SOPS 管理密钥 (见 `sops.nix`)
- 永远不要硬编码凭据
- 遵循最小权限原则

## Git 提交
- 使用约定式提交消息
- 适用时引用 issue 编号
- 保持提交的聚焦性和原子性

## 测试
- 在虚拟机中测试配置: `nixos-rebuild build-vm --flake .#hostname`
- 验证 flake: `nix flake check`

## 项目结构
这是一个基于 Nix flake 的配置仓库，包含:
- 多主机 NixOS 配置
- Home-manager 用户配置
- 可重用的模块和覆盖层
- SOPS 管理的密钥
- 通过 pkgs/ 的自定义包

### 模块使用模式
- 通过 flake 输入导入模块
- 使用 `specialArgs` 传递输入到模块
- 遵循 NixOS 模块系统约定
- 使用条件启用配置选项

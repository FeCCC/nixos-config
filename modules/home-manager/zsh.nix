{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    initContent = ''
      bindkey "^A" vi-beginning-of-line
      bindkey "^E" vi-end-of-line
    '';
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "zoxide"
        "fzf"
        "extract"
      ];
    };
  };
}

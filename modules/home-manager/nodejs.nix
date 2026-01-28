{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs
    pnpm
    yarn
  ];
  programs.zsh.initContent = ''
    export PATH=$PATH:$(npm config get prefix)/bin
    export PATH=$PATH:$(yarn global bin)
    export PATH=$PATH:$(pnpm bin -g)
  '';
}

{
  programs.nixvim.plugins.lspsaga = {
    enable = true;
    settings = {
      rename.inSelect = false;
      finder.keys.toggleOrOpen = "<CR>";
      outline.keys.toggleOrJump = "<CR>";
      lightbulb.enable = false;
    };

  };
}

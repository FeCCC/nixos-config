{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "onedark";
      editor = {
        cursorline = true;
        true-color = true;
        bufferline = "multiple";
        color-modes = true;
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
            "version-control"
          ];
          right = [
            "selections"
            "separator"
            "position"
            "separator"
            "file-encoding"
            "file-line-ending"
            "separator"
            "file-type"
          ];
          separator = "│";
        };
        whitespace.render = "all";
        indent-guides.render = true;
      };
      keys.normal = {
        "A-f" = ":format";
      };
    };
    languages = {
      language-server.pylsp.config.pylsp.plugins.black.enabled = true;
      language = [
        {
          name = "c";
          language-id = "c";
          scope = "source.c";
          language-servers = ["clangd"];
        }
        {
          name = "rust";
          scope = "source.rust";
          roots = ["Cargo.lock"];
          language-servers = ["rust-analyzer"];
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = ["taplo"];
          formatter = {
            command = "taplo";
            args = ["fmt" "-"];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["pylsp"];
        }
      ];
    };
  };
}

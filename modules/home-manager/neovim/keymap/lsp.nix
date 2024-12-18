{
  programs.nixvim.plugins.lsp.keymaps.extra = [
    {
      action = ":lua vim.lsp.buf.declaration()<CR>";
      key = "gD";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Go to Declaration";
      };
    }
    {
      action = ":Lspsaga goto_definition<CR>";
      key = "gd";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Go to Definition";
      };
    }
    {
      action = ":Lspsaga finder<CR>";
      key = "gr";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Go to References";
      };
    }
    {
      action = ":lua vim.lsp.buf.implementation()<CR>";
      key = "gi";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Go to Type Implementation";
      };
    }
    {
      action = ":lua vim.lsp.buf.type_definition()<CR>";
      key = "gt";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Go to Type Definition";
      };
    }
    {
      action = ":Lspsaga hover_doc<CR>";
      key = "K";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "LSP Hover";
      };
    }
    {
      action = ":lua vim.lsp.buf.signature_help()<CR>";
      key = "<C-k>";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Signature HHelp";
      };
    }
    {
      action = ":Lspsaga rename<CR>A";
      key = "<leader>rn";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Rename";
      };
    }
    {
      action = ":Lspsaga outline<CR>";
      key = "<A-o>";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Symbols Outline";
      };
    }
    {
      action = ":Lspsaga code_action<CR>";
      key = "<leader>ac";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Code Actions";
      };
    }
    {
      action = ":lua vim.lsp.buf.format({ async = true })<CR>";
      key = "<A-S-f>";
      mode = ["n"];
      options = {
        buffer = true;
        desc = "Format";
      };
    }
  ];
}

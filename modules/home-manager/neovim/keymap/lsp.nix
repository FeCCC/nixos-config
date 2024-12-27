{
  programs.nixvim.plugins.lsp.keymaps.extra = [
    {
      action = ":lua vim.lsp.buf.declaration()<CR>";
      key = "gD";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Go to Declaration";
      };
    }
    {
      action = ":Lspsaga goto_definition<CR>";
      key = "gd";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Go to Definition";
      };
    }
    {
      action = ":Lspsaga finder<CR>";
      key = "gr";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Go to References";
      };
    }
    {
      action = ":lua vim.lsp.buf.implementation()<CR>";
      key = "gi";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Go to Type Implementation";
      };
    }
    {
      action = ":lua vim.lsp.buf.type_definition()<CR>";
      key = "gt";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Go to Type Definition";
      };
    }
    {
      action = ":Lspsaga hover_doc<CR>";
      key = "K";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "LSP Hover";
      };
    }
    {
      action = ":lua vim.lsp.buf.signature_help()<CR>";
      key = "<C-k>";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Signature HHelp";
      };
    }
    {
      action = ":Lspsaga rename<CR>A";
      key = "<leader>rn";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Rename";
      };
    }
    {
      action = ":Lspsaga outline<CR>";
      key = "<A-o>";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Symbols Outline";
      };
    }
    {
      action = ":Lspsaga code_action<CR>";
      key = "<leader>ac";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Code Actions";
      };
    }
    {
      action.__raw = ''
        function()
            if vim.fn.mode() == "v" then
                local _, v_row, _ = unpack(vim.fn.getpos('v'))
                local _, c_row, _ = unpack(vim.fn.getpos('.'))
                local start_row, end_row
                if v_row < c_row then
                    start_row = v_row
                    end_row = c_row
                elseif v_row > c_row then
                    start_row = c_row
                    end_row = v_row
                elseif v_row == c_row then
                    start_row = v_row
                    end_row = v_row
                end
                require('conform').format({
                    range = {
                        ["start"] = { start_row, 0 },
                        ["end"] = { end_row, 0 },
                    }
                })
            else
                require('conform').format()
            end
        end
      '';
      key = "<A-S-f>";
      mode = ["n" "v"];
      options = {
        buffer = true;
        silent = true;
        desc = "Format";
      };
    }
    {
      action = ":Trouble diagnostics toggle<CR>";
      key = "<leader>xx";
      mode = ["n"];
      options = {
        buffer = true;
        silent = true;
        desc = "Diagnostics (Trouble)";
      };
    }
  ];
}

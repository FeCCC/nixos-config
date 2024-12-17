{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      live-grep-args = {
        enable = true;
        settings = {
          auto_quoting = true;
          mappings = {
            i = {
              "<C-i>" = {
                __raw = "require(\"telescope-live-grep-args.actions\").quote_prompt({ postfix = \" --iglob \" })";
              };
              "<C-k>" = {
                __raw = "require(\"telescope-live-grep-args.actions\").quote_prompt()";
              };
              "<C-space>" = {
                __raw = "require(\"telescope.actions\").to_fuzzy_refine";
              };
            };
          };
        };
      };
      fzf-native = {
        enable = true;
        settings = {
          fuzzy = true; # false will only do exact matching
          override_generic_sorter = true; # override the generic sorter
          override_file_sorter = true; # override the file sorter
          case_mode = "smart_case"; # or "ignore_case" or "respect_case"
        };
      };
    };
  };
}

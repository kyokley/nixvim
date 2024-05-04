{
  plugins = {
    lualine.enable = true;
    undotree.enable = true;
    marks.enable = true;
    indent-o-matic.enable = true;
    rainbow-delimiters.enable = true;
    illuminate.enable = true;
    alpha = {
        enable = true;
        theme = "startify";
    };
    gitgutter.enable = true;

    nvim-tree = {
        enable = true;
    };
    telescope = {
        enable = true;
        keymaps = {
            "<C-p>" = "git_files";
            "<leader>8" = "grep_string";
            "<leader>a" = "live_grep";
            "<F4>" = "lsp_document_symbols";
        };
    };
    treesitter.enable = true;

    lsp = {
      enable = true;
      servers = {
        lua-ls.enable = true;
        ruff-lsp.enable = true;
        pylsp.enable = true;
        nil_ls.enable = true;
      };
    };
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];

      settings.mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = ''
            cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          {"i", "s"})
          '';
        "<S-Tab>" = ''
            cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          {"i", "s"})
          '';
        };
      };
    };
}

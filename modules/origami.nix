{
  flake.nixvimModules.full = {
    plugins = {
      origami = {
        enable = false; # Disabling for performance reasons
        settings = {
          useLspFoldsWithTreesitterFallback = {
            enabled = true;
            foldmethodIfNeitherIsAvailable = "indent";
          };
          pauseFoldsOnSearch = true;
        };
        luaConfig.post = ''
          -- default settings
          require("origami").setup {
              foldtext = {
                  enabled = true,
                  padding = 3,
                  lineCount = {
                      template = "⤢ %d lines", -- `%d` is replaced with the number of folded lines
                      hlgroup = "Comment",
                  },
                  diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
                  gitsignsCount = true, -- requires `gitsigns.nvim`
              },
              autoFold = {
                  enabled = true,
                  kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
              },
              foldKeymaps = {
                  setup = true, -- modifies `h` and `l`
                  hOnlyOpensOnFirstColumn = false,
              },
          }
        '';
      };
    };
  };
}

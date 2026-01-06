{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minimal.nix
  ];

  extraPython3Packages = p:
    with p; [
      bandit
    ];

  plugins = {
    numbertoggle.enable = true;
    colorizer.enable = true;
    treesitter = {
      enable = true;
      settings.highlight.enable = true;
    };
    telescope.enable = true;
    rainbow-delimiters.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];

      settings.mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
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
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = ["stylua"];
          python = ["ruff_format" "isort"];
          nix = ["alejandra"];
          html = ["htmlbeautifier"];
          htmldjango = ["djhtml"];
          json = ["jq"];
          javascript = ["prettier"];
          bash = ["shfmt"];
          yaml = ["yamlfmt"];
        };
        formatters = {
          stylua.command = lib.getExe pkgs.stylua;
          isort.command = lib.getExe pkgs.isort;
          alejandra.command = lib.getExe pkgs.alejandra;
          htmlbeautifier.command = lib.getExe pkgs.rubyPackages.htmlbeautifier;
          jq.command = lib.getExe pkgs.jq;
          djhtml = {
            command = lib.getExe pkgs.djhtml;
            stdin = true;
            args = ["-"];
          };
          prettier.command = lib.getExe pkgs.nodePackages.prettier;
          shfmt.command = lib.getExe pkgs.shfmt;
          yamlfmt.command = lib.getExe pkgs.yamlfmt;
        };
        default_format_opts.lsp_format = "fallback";
      };
    };
    diffview = {
      enable = true;
      settings.enhanced_diff_hl = true;
    };
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
    nvim-ufo = {
      enable = true;
      settings = {
        fold_virt_text_handler = ''
          function(virtText, lnum, endLnum, width, truncate)
              local bufnr = 0

              local diagnostics = vim.diagnostic.get(bufnr)
              local counts = {
                [vim.diagnostic.severity.ERROR] = 0,
                [vim.diagnostic.severity.WARN] = 0,
                [vim.diagnostic.severity.INFO] = 0,
                [vim.diagnostic.severity.HINT] = 0,
              }

              for _, diag in ipairs(diagnostics) do
                if diag.lnum >= lnum and diag.lnum <= endLnum then
                  counts[diag.severity] = counts[diag.severity] + 1
                end
              end

              local suffix = (' 󰁂 %d '):format(endLnum - lnum)

              if counts[vim.diagnostic.severity.ERROR] > 0 then
                suffix = suffix .. (' 󰅚 %d '):format(counts[vim.diagnostic.severity.ERROR])
              end

              if counts[vim.diagnostic.severity.WARN] > 0 then
                suffix = suffix .. ('  %d '):format(counts[vim.diagnostic.severity.WARN])
              end

              local newVirtText = {}

              local sufWidth = vim.fn.strdisplaywidth(suffix)
              local targetWidth = width - sufWidth
              local curWidth = 0
              for _, chunk in ipairs(virtText) do
                  local chunkText = chunk[1]
                  local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if targetWidth > curWidth + chunkWidth then
                      table.insert(newVirtText, chunk)
                  else
                      chunkText = truncate(chunkText, targetWidth - curWidth)
                      local hlGroup = chunk[2]
                      table.insert(newVirtText, {chunkText, hlGroup})
                      chunkWidth = vim.fn.strdisplaywidth(chunkText)
                      -- str width returned from truncate() may less than 2nd argument, need padding
                      if curWidth + chunkWidth < targetWidth then
                          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                      end
                      break
                  end
                  curWidth = curWidth + chunkWidth
              end
              table.insert(newVirtText, {suffix, 'MoreMsg'})
              return newVirtText
          end
        '';
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    vista-vim
    fzf-vim # Needed to use vim version to work with vista-vim
    vim-mundo
    vim-exchange
    vim-rooter
    conform-nvim
  ];

  extraConfigLua = ''
    -- {{{ Vista
    vim.g.vista_highlight_whole_line = 1
    vim.g.vista_blank = {0, 0}
    vim.g.vista_top_level_blink = {0, 0}
    vim.g.vista_echo_cursor = 1
    vim.g.vista_echo_cursor_strategy = 'floating_win'
    vim.g.vista_cursor_delay = 1000
    vim.g.vista_fzf_preview = {}
    -- }}}

    -- Rooter {{{
    vim.g.rooter_silent_chdir = 1
    vim.g.rooter_manual_only = 1
    -- }}}

    -- Vim-Mundo {{{
    vim.g.mundo_preview_bottom = 1
    -- vim.g.mundo_close_on_revert = 1
    -- }}}

    -- {{{ Telescope Config
    local select_one_or_multi = function(prompt_bufnr)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format('%s %s', 'edit', j.path))
          end
        end
      else
        require('telescope.actions').select_default(prompt_bufnr)
      end
    end

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<CR>'] = select_one_or_multi,
          }
        }
      }
    }
    -- }}}
  '';
}

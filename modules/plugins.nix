{
  flake.nixvimModules = {
    minimal = {lib, ...}: {
      plugins = {
        web-devicons.enable = true;
        vim-bbye.enable = true;
        lualine = {
          enable = true;
          settings.options.globalstatus = false;
        };
        marks.enable = true;
        indent-o-matic = {
          enable = true;
          settings = {
            max_lines = 2048;
            skip_multiline = false;
            standard_widths = [
              2
              4
              8
            ];
          };
        };
        illuminate.enable = true;
        alpha = {
          enable = true;
          theme = "startify";
        };

        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = false;
            numhl = false;
            signs = {
              add.text = "+";
              change.text = "~";
            };
          };
        };

        nvim-tree = {
          enable = true;
          autoClose = true;
        };

        telescope = {
          enable = lib.mkDefault false;
          keymaps = {
            # <leader>8 is mapped in key_maps.nix
            # <leader>a is mapped in key_maps.nix
            "<C-p>" = "git_files";
            "<leader>a" = "live_grep";
          };
        };
        treesitter.enable = lib.mkDefault false;
        cmp.enable = lib.mkDefault false;
      };
    };

    full = {
      pkgs,
      lib,
      ...
    }: {
      plugins = {
        numbertoggle = {
          enable = true;
        };
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
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
            ];

            formatting = {
              format.__raw = ''
                function(entry, vim_item)
                    local highlights_info = require("colorful-menu").cmp_highlights(entry)

                    -- highlight_info is nil means we are missing the ts parser, it's
                    -- better to fallback to use default `vim_item.abbr`. What this plugin
                    -- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
                    if highlights_info ~= nil then
                        vim_item.abbr_hl_group = highlights_info.highlights
                        vim_item.abbr = highlights_info.text
                    end

                    return vim_item
                end
              '';
            };

            window = {
              completion = {
                border = "rounded";
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
              };
              documentation = {
                border = "rounded";
              };
            };

            mapping = {
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
        };
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              lua = ["stylua"];
              python = [
                "ruff_format"
                "ruff_organize_imports"
              ];
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
              ruff_format.command = lib.getExe pkgs.ruff;
              ruff_organize_imports.command = lib.getExe pkgs.ruff;
              alejandra.command = lib.getExe pkgs.alejandra;
              htmlbeautifier.command = lib.getExe pkgs.rubyPackages.htmlbeautifier;
              jq.command = lib.getExe pkgs.jq;
              djhtml = {
                command = lib.getExe pkgs.djhtml;
                stdin = true;
                args = ["-"];
              };
              prettier.command = lib.getExe pkgs.prettier;
              shfmt.command = lib.getExe pkgs.shfmt;
              yamlfmt.command = lib.getExe pkgs.yamlfmt;
            };
            default_format_opts.lsp_format = "fallback";
          };
        };
        lint = {
          enable = true;
          autoCmd = {
            event = [
              "TextChanged"
              "BufWinEnter"
              "InsertLeave"
            ];
            group = "lint_setup";
          };
          linters = {
            ruff.cmd = lib.getExe pkgs.ruff;
            bandit = {
              cmd = lib.getExe' pkgs.bandit "bandit";
              args = [
                "-f"
                "custom"
                "--msg-template"
                "{line}:{col}:{severity}:{test_id} {msg}"
                "-x"
                ".svn,CVS,.bzr,.hg,.git,__pycache__,.tox,.eggs,*.egg,*/test_*.py"
              ];
            };
            hadolint.cmd = lib.getExe pkgs.hadolint;
            jsonlint.cmd = lib.getExe' pkgs.python313Packages.demjson3 "jsonlint";
            tflint.cmd = lib.getExe pkgs.tflint;
            statix.cmd = lib.getExe pkgs.statix;
          };
          lintersByFt = {
            nix = ["statix"];
            python = [
              "ruff"
              "bandit"
            ];
            dockerfile = [
              "hadolint"
            ];
            json = [
              "jsonlint"
            ];
            terraform = [
              "tflint"
            ];
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
          luaConfig.post = ''
            -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
          '';
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

                  local suffix = (' 󰁂 %d  '):format(endLnum - lnum)

                  if counts[vim.diagnostic.severity.ERROR] > 0 then
                    suffix = suffix .. ('󰅚 %d '):format(counts[vim.diagnostic.severity.ERROR])
                  end

                  if counts[vim.diagnostic.severity.WARN] > 0 then
                    suffix = suffix .. (' %d '):format(counts[vim.diagnostic.severity.WARN])
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
        snacks = {
          enable = true;
          settings = {
            animate.enable = true;
            bigfile.enable = true;
            dim.enable = true;
            indent.enable = true;
            input.enable = true;
            notifier.enable = true;
            picker.enable = true;
            scroll.enable = true;
            statuscolumn = {
              enable = true;
              left = [
                "mark"
                "sign"
                "git"
              ];
              right = [
                "fold"
              ];
            };
            terminal.enable = true;
          };
        };
        colorful-menu.enable = true;
        blink-cmp = {
          enable = false;
          settings = {
            appearance = {
              nerd_font_variant = "normal";
              use_nvim_cmp_as_default = true;
            };
            completion = {
              accept = {
                auto_brackets = {
                  enabled = true;
                  semantic_token_resolution = {
                    enabled = false;
                  };
                };
              };
              documentation = {
                auto_show = true;
              };
              menu = {
                auto_show = true;
                draw = {
                  # columns = {
                  #   "kind_icon" = {
                  #     kind = { };
                  #   };

                  #   "label" = {
                  #     gap = 1;
                  #   };
                  # };
                  components = {
                    label = {
                      text.__raw = ''
                        function(ctx)
                            return require("colorful-menu").blink_components_text(ctx)
                        end
                      '';
                      highlight.__raw = ''
                        function(ctx)
                            return require("colorful-menu").blink_components_highlight(ctx)
                        end
                      '';
                    };
                  };
                };
              };
            };
            keymap = {
              preset = "super-tab";
            };
            signature = {
              enabled = true;
            };
            sources = {
              default = [
                "lsp"
                "buffer"
              ];
              per_filetype = {
                opencode_ask = [
                  "lsp"
                  "buffer"
                ];
              };
              cmdline = [];
              providers = {
                buffer = {
                  score_offset = -7;
                };
                lsp = {
                  fallbacks = [];
                };
              };
            };
          };
        };

        modicator = {
          enable = true;
          settings = {
            integration = {
              lualine = {
                enabled = true;
              };
            };
            highlights = {
              defaults = {
                bold = true;
                italic = true;
              };
            };
          };
        };
      };

      extraConfigLua = ''

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
    };
  };
}

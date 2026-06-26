{
  flake.nixvimModules = {
    minimal = {lib, ...}: {
      plugins = {
        web-devicons.enable = true;
        vim-bbye.enable = true;
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
        rainbow-delimiters.enable = true;
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
      };
    };
  };
}

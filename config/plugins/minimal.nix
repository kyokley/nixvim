{
  pkgs,
  lib,
  ...
}: {
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
      settings = {
        layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            opts = {
              hl = "Type";
              position = "center";
            };
            type = "text";
            val = [
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                on_press = lib.nixvim.mkRaw "function() vim.cmd[[ene]] end";
                opts = {
                  shortcut = "n";
                };
                type = "button";
                val = "  New file";
              }
              {
                on_press = lib.nixvim.mkRaw "function() vim.cmd[[qa]] end";
                opts = {
                  shortcut = "q";
                };
                type = "button";
                val = " Quit Neovim";
              }
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            opts = {
              hl = "Keyword";
              position = "center";
            };
            type = "text";
            val = "Inspiring quote here.";
          }
        ];
      };
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

  extraPackages = with pkgs; [
    ripgrep
    fd
    jq
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-cokeline
  ];

  extraConfigLua = ''
    -- Cokeline Bufferline Config {{{
        local get_hex = require('cokeline/utils').get_hex

            local red = 'red'
            local yellow = 'yellow'
            local orange = 'orange'
            local blue = "darkblue"
            local green = "green"

            local components = {
                space = { text = ' ' , bg = 'none'},
                left_cap = {
                    text = function(buffer) return buffer.is_focused and '' or ' ' end,
                    fg = function(buffer)
                        return buffer.is_focused and blue or 'none'
                        end,
                    bg = 'none',
                },
                devicon = {
                    text = function(buffer) return buffer.devicon.icon .. ' ' end,
                    fg = function(buffer) return buffer.devicon.color end,
                },
                index = {
                    text = function(buffer) return buffer.number .. ': ' end,
                },
                prefix = {
                    text = function(buffer) return buffer.unique_prefix end,
                    fg = function(buffer)
                        return buffer.is_modified and orange or nil
                        end,
                    style = 'italic',
                },
                filename = {
                    text = function(buffer)
                        return buffer.filename
                        end,
                    fg = function(buffer)
                        return buffer.is_modified and orange or nil
                        end,
                    style = function(buffer)
                        if buffer.is_focused then
                            return "bold"
                                end
                                return nil
                                end
                },
                readonly = {
                    text = function(buffer)
                        if buffer.is_readonly then
                            return " 🔒"
                                end
                                return ""
                                end
                },
                unsaved = {
                    text = function(buffer)
                        return buffer.is_modified and ' ●' or '  '
                        end,
                    fg = function(buffer)
                        return buffer.is_modified and "#e5c463" or nil
                        end,
                    truncation = { priority = 1 },
                },
                right_cap = {
                    text = function(buffer) return buffer.is_focused and '' or ' ' end,
                    fg = function(buffer)
                        return buffer.is_focused and blue or 'none'
                        end,
                    bg = 'none',
                },
                diagnostic_errors = {
                    text = function(buffer)
                        return
                        (buffer.diagnostics.errors ~= 0 and ' 󰅚 ' .. buffer.diagnostics.errors)
                        or ""
                        end,
                    fg = function(buffer)
                        return
                        (buffer.diagnostics.errors ~= 0 and red)
                        or nil
                        end,
                    truncation = { priority = 1 },
                },
                diagnostic_warnings = {
                    text = function(buffer)
                        return
                        (buffer.diagnostics.warnings ~= 0 and ' 󰀪 ' .. buffer.diagnostics.warnings)
                        or ""
                        end,
                    fg = function(buffer)
                        return
                        (buffer.diagnostics.warnings ~= 0 and yellow)
                        or nil
                        end,
                    truncation = { priority = 1 },
                },
            }

        require('cokeline').setup({
                default_hl = {
                fg = function(buffer)
                -- return buffer.is_focused and get_hex('Normal', 'fg') or 'none'
                return buffer.is_focused and 'none'
                end,
                bg = function(buffer)
                return buffer.is_focused and blue or 'none'
                end,
                },

                components = {
                components.space,
                components.left_cap,
                components.devicon,
                components.index,
                components.prefix,
                components.filename,
                components.diagnostic_errors,
                components.diagnostic_warnings,
                components.readonly,
                -- components.unsaved,
                components.right_cap,
                },

                buffers = {
                  new_buffers_position = 'number'
                },
        })
        -- }}}
  '';
}

{
  flake.nixvimModules = {
    minimal = {lib, ...}: {
      plugins = {
        telescope = {
          enable = lib.mkDefault false;
          keymaps = {
            # <leader>8 is mapped in key_maps.nix
            # <leader>a is mapped in key_maps.nix
            "<C-p>" = "git_files";
          };
        };
      };

      keymaps = [
        {
          key = "<leader>a";
          action.__raw = ''
            function()
                local root = vim.fn.systemlist({"git", "-C", vim.fn.getcwd(), "rev-parse", "--show-toplevel"})[1]
                if vim.v.shell_error ~= 0 or not root or root == "" then
                  root = vim.fn.getcwd()
                end
                require('telescope.builtin').live_grep({cwd=root})
            end
          '';
        }
      ];
    };

    full = {
      extraConfigLua = ''
        -- {{{ Telescope Config
        local select_one_or_multi = function(prompt_bufnr)
          local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          if not vim.tbl_isempty(multi) then
            require('telescope.actions').close(prompt_bufnr)
            for _, j in ipairs(multi) do
              if j.path ~= nil then
                vim.cmd.edit({args = {j.path}})
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

      keymaps = [
        {
          key = "<leader>8";
          action.__raw = ''
            function()
                local telescope = require('telescope.builtin')
                telescope.grep_string({theme = 'dropdown', cwd=vim.fn['FindRootDirectory']() ~= "" and vim.fn['FindRootDirectory']() or vim.fn.getcwd()})
            end
          '';
        }
        {
          key = "<leader>a";
          action.__raw = ''
            function()
                local telescope = require('telescope')
                local root = vim.fn.systemlist({"git", "-C", vim.fn.getcwd(), "rev-parse", "--show-toplevel"})[1]
                if vim.v.shell_error ~= 0 or not root or root == "" then
                  root = vim.fn.getcwd()
                end
                telescope.extensions.live_grep_args.live_grep_args({theme = 'dropdown', cwd=root})
            end
          '';
        }
      ];

      plugins = {
        telescope = {
          enable = true;
          extensions = {
            live-grep-args = {
              enable = true;
              settings = {
                auto_quoting = true;
              };
            };
          };
        };
      };
    };
  };
}

{
  flake.nixvimModules = {
    minimal = {lib, ...}: {
      plugins.telescope.enable = lib.mkDefault false;
    };

    full = {
      extraFiles."lua/nixvim/root.lua".text = ''
        local M = {}

        function M.current_buffer_root()
          local filename = vim.api.nvim_buf_get_name(0)
          if filename == "" then
            return vim.fn.getcwd(), false
          end

          local git_root = vim.fs.root(filename, ".git")
          return git_root or vim.fn.fnamemodify(filename, ":h"), git_root ~= nil
        end

        return M
      '';

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
                local cwd = require('nixvim.root').current_buffer_root()
                telescope.grep_string({theme = 'dropdown', cwd=cwd})
            end
          '';
        }
        {
          key = "<leader>a";
          action.__raw = ''
            function()
                local telescope = require('telescope')
                local cwd = require('nixvim.root').current_buffer_root()
                telescope.extensions.live_grep_args.live_grep_args({theme = 'dropdown', cwd=cwd})
            end
          '';
        }
        {
          key = "<C-p>";
          action.__raw = ''
            function()
                local telescope = require('telescope.builtin')
                local cwd, is_git_repo = require('nixvim.root').current_buffer_root()
                if is_git_repo then
                  telescope.git_files({cwd = cwd})
                else
                  telescope.find_files({cwd = cwd})
                end
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

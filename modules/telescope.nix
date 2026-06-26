{
  flake.nixvimModules.full = {
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
              local telescope = require('telescope.builtin')
              telescope.live_grep({theme = 'dropdown', cwd=vim.fn['FindRootDirectory']() ~= "" and vim.fn['FindRootDirectory']() or vim.fn.getcwd()})
          end
        '';
      }
    ];

    plugins = {
      telescope.enable = true;
    };
  };
}

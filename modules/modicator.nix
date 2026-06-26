{
  flake.nixvimModules.minimal = {
    plugins = {
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

    extraConfigLuaPost = ''
      -- Force modicator to re-apply highlights with the now-correct lualine theme.
      -- Modicator's use_lualine_mode_highlights skips highlights that already exist,
      -- and they were already created from the default lualine theme during plugin setup.
      -- We must clear them first so modicator re-creates them from bubbles_theme.
      pcall(function()
        for _, name in ipairs({
          'NormalMode', 'InsertMode', 'VisualMode', 'CommandMode',
          'ReplaceMode', 'SelectMode', 'TerminalMode', 'TerminalnormalMode',
        }) do
          vim.api.nvim_set_hl(0, name, {})
        end
        require('modicator.integration.lualine').use_lualine_mode_highlights(nil)
        local modicator = require('modicator')
        modicator.set_cursor_line_highlight(
          modicator.hl_name_from_mode(vim.api.nvim_get_mode().mode)
        )
      end)

    '';
  };
}

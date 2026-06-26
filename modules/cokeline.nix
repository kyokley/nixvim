{
  flake.nixvimModules.minimal = {pkgs, ...}: {
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
      local white = "white"

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
              fg = function(buffer)
                  return buffer.is_modified and orange or nil
                  end,
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
                  return buffer.is_modified and orange or nil
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
              return buffer.is_focused and white
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
  };
}

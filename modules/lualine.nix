{
  flake.nixvimModules.minimal = {
    plugins = {
      lualine = {
        enable = true;
        settings.options.globalstatus = false;
      };
    };

    extraConfigLua = ''
      -- Bubbles config for lualine
      -- Author: lokesh-krishna
      -- MIT license, see LICENSE for more details.
      local colors = {
        blue   = '#80a0ff',
        cyan   = '#79dac8',
        black  = '#080808',
        white  = '#c6c6c6',
        red    = '#ff5189',
        yellow = '#e0af68',
        green  = '#9ece6a',
        violet = '#d183e8',
        grey   = '#303030',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
        },

        insert = { a = { fg = colors.black, bg = colors.red } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },

        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white },
        },
      }

      local conflict = {
          function()
              if vim.fn.search('^[<=>]\\{7,\\}\\( \\|$\\)', 'nw') ~= 0 then
                  return "[con!]"
              else
                  return ""
              end
          end,
          separator = { left = '', right = '' },
          color = { bg = colors.red, fg = colors.black, gui = "italic,bold" },
      }

      local whitespace = {
          function()
              if vim.fn.search('\\s\\+$', 'nw') ~= 0 then
                  return "[\\s]"
              else
                  return ""
              end
          end,
          separator = { left = '', right = '' },
          color = { bg = colors.red, fg = colors.black, gui = "italic,bold" },
      }

      local jj_cache = {}
      local function jj_status()
        if vim.fn.executable('jj') ~= 1 then return "", false end

        local buf = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)
        local start = name ~= "" and vim.bo[buf].buftype == ""
          and vim.fs.abspath(name) or vim.fn.getcwd()
        local root = vim.fs.root(start, '.jj')
        if not root then return "", false end

        local entry = jj_cache[root] or {
          text = "", warning = false, pending = false, time = -math.huge,
        }
        jj_cache[root] = entry
        local now = vim.uv.now()
        if not entry.pending and now - entry.time >= 5000 then
          entry.pending, entry.time = true, now
          local ok = pcall(vim.system, {
            'jj', '--no-pager', '--color', 'never', 'log',
            '-r', '@', '--no-graph', '-T',
            'if(!empty && !description, "1", "0") ++ "\\n" ++ change_id.short(4) ++ if(description, " " ++ description.first_line(), "")',
          }, { cwd = root, text = true, timeout = 2000 }, function(result)
            vim.schedule(function()
              entry.pending = false
              if result.code == 0 then
                local warning, display = result.stdout:match('^([01])\n(.-)\n?$')
                if warning then
                  entry.warning = warning == "1"
                  -- Strip the description prefix while preserving the change ID.
                  display = display:gsub('^(%S+ )%S+: ', '%1')
                  display = display:gsub('^(%S+ )(.*)$', function(prefix, description)
                    if vim.fn.strchars(description) > 24 then
                      description = vim.fn.strcharpart(description, 0, 23) .. '…'
                    end
                    return prefix .. description
                  end)
                  entry.text = vim.trim(display:gsub('[%c]', ' ')):gsub('%%', '%%%%')
                else
                  entry.text, entry.warning = "", false
                end
              else
                entry.text, entry.warning = "", false
              end
              require('lualine').refresh { place = { 'statusline' } }
            end)
          end)
          if not ok then
            entry.text, entry.warning, entry.pending = "", false, false
          end
        end
        return entry.text, entry.warning
      end

      require('lualine').setup {
        options = {
          theme = bubbles_theme,
          component_separators = "",
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 }},
          lualine_b = {
            'filename',
            {
              jj_status,
              color = function()
                local _, warning = jj_status()
                return { fg = colors.black, bg = warning and colors.yellow or colors.green }
              end,
            },
            { 'branch', cond = function() return jj_status() == "" end },
          },
          lualine_c = {
            function()
              -- invoke `progress` here.
              return require('lsp-progress').progress()
            end
          },
          lualine_x = {conflict, whitespace},
          lualine_y = { 'filetype', 'fileformat', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
      }
    '';
  };
}

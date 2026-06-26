{
  flake.nixvimModules.full = {
    plugins = {
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
    };
  };
}

{
  flake.nixvimModules.full = {
    plugins = {
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
    };
  };
}

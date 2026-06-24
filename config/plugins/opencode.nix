{pkgs, ...}: {
  plugins.opencode = {
    enable = true;
    settings = {
      auto_reload = true;
      server = {
        start.__raw = ''
          function()
            require("snacks.terminal").toggle('opencode --port',
            { win = { position = "right", enter = false}})
          end
        '';
      };
    };
  };

  keymaps = [
    {
      key = "<leader>o";
      action.__raw = ''
        function()
          require("opencode").ask("@this: ")
        end
      '';
      mode = ["n" "t"];
      options.desc = "Ask Opencode";
    }
    {
      mode = ["n" "x"];
      key = "go";
      action.__raw = ''
        function()
          return require("opencode").operator("@this ")
        end
      '';
      options = {
        desc = "Add range to opencode";
        expr = true;
      };
    }
    {
      mode = "n";
      key = "goo";
      action.__raw = ''
        function()
          return require("opencode").operator("@this ") .. "_"
        end
      '';
      options = {
        desc = "Add line to opencode";
        expr = true;
      };
    }
    {
      key = "jj";
      action.__raw = ''
        function ()
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_win_get_buf(win)

          local buf_name = vim.api.nvim_buf_get_name(buf)

          local opencode_index = string.find(buf_name, "opencode")
          if opencode_index then
            local whitespace_index = string.find(buf_name, " ")
            if whitespace_index and whitespace_index > opencode_index then
              local key = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
              vim.api.nvim_feedkeys(key, 'n', false)
              return
            end
          end
          vim.api.nvim_feedkeys("jj", 'n', false)
        end
      '';
      mode = ["t"];
      options.nowait = true;
    }
    {
      key = "kk";
      action.__raw = ''
        function ()
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_win_get_buf(win)

          local buf_name = vim.api.nvim_buf_get_name(buf)

          local opencode_index = string.find(buf_name, "opencode")
          if opencode_index then
            local whitespace_index = string.find(buf_name, " ")
            if whitespace_index and whitespace_index > opencode_index then
              local key = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
              vim.api.nvim_feedkeys(key, 'n', false)
              return
            end
          end

          vim.api.nvim_feedkeys("kk", 'n', false)
        end
      '';
      mode = ["t"];
    }
  ];
}

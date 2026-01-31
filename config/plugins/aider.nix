{pkgs, ...}: {
  imports = [
    ./full.nix
  ];

  plugins = {
    snacks.enable = true;
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-aider";
      src = pkgs.fetchFromGitHub {
        owner = "GeorgesAlkhouri";
        repo = "nvim-aider";
        rev = "main";
        hash = "sha256-LHSDfn9I+Ff83u8DZlom7fgZNwqSZ1h72y6NJq0eKTw=";
      };
      doCheck = false;
    })
  ];

  extraConfigLua = ''
    require('nvim_aider').setup {
      aider_cmd = vim.env.NIXVIM_AIDER_CMD or "aider",
      args = { "--pretty", "--no-auto-commits", "--model=" .. (vim.env.NIXVIM_AIDER_MODEL or "ollama_chat/gpt-oss"), vim.env.NIXVIM_AIDER_EXTRA_ARGS or "" },
      auto_reload = true
    }

  '';

  keymaps = [
    {
      key = "<space>a/";
      action = "<C-\\><C-n>:Aider toggle<cr>";
      mode = ["n" "x" "t"];
    }
    {
      key = "<space>as";
      action = ":Aider send<cr>";
      mode = ["n" "x"];
    }
    {
      key = "<space>ac";
      action = ":Aider command<cr>";
      mode = ["n" "x"];
    }
    {
      key = "<space>ab";
      action = ":Aider buffer<cr>";
      mode = ["n" "x"];
    }
    {
      key = "<space>aa";
      action = ":Aider add<cr>";
      mode = ["n" "x"];
    }
    {
      key = "<space>a-";
      action = ":Aider drop<cr>";
      mode = ["n" "x"];
    }
    {
      key = "<space>ar";
      action = ":Aider add readonly<cr>";
      mode = ["n" "x"];
    }
    # {
    #   key = "<space>aR";
    #   action = ":Aider reset<cr>";
    #   mode = ["n" "x"];
    # }
    {
      key = "<space>a+";
      action = ":AiderTreeAddFile<cr>";
      mode = ["n" "x"];
    }
    {
      key = "jj";
      action.__raw = ''
        function ()
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_win_get_buf(win)

          local buf_name = vim.api.nvim_buf_get_name(buf)

          local aider_index = string.find(buf_name, "aider")
          if aider_index then
            local whitespace_index = string.find(buf_name, " ")
            if whitespace_index and whitespace_index > aider_index then
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

          local aider_index = string.find(buf_name, "aider")
          if aider_index then
            local whitespace_index = string.find(buf_name, " ")
            if whitespace_index and whitespace_index > aider_index then
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

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
      args = { "--pretty", "--no-auto-commits", "--model=" .. (vim.env.NIXVIM_AIDER_MODEL or "ollama_chat/gpt-oss"), vim.env.NIXVIM_AIDER_EXTRA_ARGS or "" }
    }
  '';

  keymaps = [
    {
      key = "jj";
      action = "<C-\\><C-n>";
      mode = ["t"];
    }
    {
      key = "kk";
      action = "<C-\\><C-n>";
      mode = ["t"];
    }
    {
      key = "<space>ai";
      action = ":Aider toggle<cr>";
      mode = ["n" "x"];
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
      key = "<space>a+";
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
  ];
}

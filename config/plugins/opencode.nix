{
  plugins.opencode = {
    enable = true;
    settings = {
      auto_reload = true;
    };
  };

  keymaps = [
    {
      key = "<leader>o";
      action.__raw = ''
        function()
          require("opencode").toggle()
          vim.cmd("stopinsert")
        end
      '';
      mode = ["n" "t"];
      options.desc = "Toggle Opencode";
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
  ];
}

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
      action.__raw = ''function() require("opencode").toggle() end'';
      mode = ["n" "t"];
    }
  ];
}

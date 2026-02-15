{
  plugins = {
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };
    copilot-cmp = {
      enable = true;
      settings = {
        event = [
          "InsertEnter"
          "LspAttach"
        ];
        fix_pairs = false;
      };
    };
    cmp.settings.sources = [
      {name = "copilot";}
    ];
  };
}

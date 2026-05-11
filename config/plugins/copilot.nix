{
  pkgs,
  inputs,
  ...
}: {
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
      package = pkgs.vimPlugins.copilot-cmp.overrideAttrs (_: {
        src = inputs.copilot-cmp;
      });
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

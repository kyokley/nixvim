{
  flake.nixvimModules.common = {
    colorschemes = {
      catppuccin = {
        enable = false;
        settings.flavour = "mocha";
      };

      nightfox = {
        enable = false;
        settings.flavor = "terafox";
        # settings.flavor = "carbonfox";
      };

      onedark.enable = true;
    };

    match = {
      ErrorMsg = ''^\(<\|=\|>\)\{7,\}\([^=].\+\)\?$'';
    };
  };
}

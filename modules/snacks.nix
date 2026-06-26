{
  flake.nixvimModules.full = {
    plugins = {
      snacks = {
        enable = true;
        settings = {
          animate.enable = true;
          bigfile.enable = true;
          dim.enable = true;
          indent.enable = true;
          input.enable = true;
          notifier.enable = true;
          picker.enable = true;
          scroll.enable = true;
          statuscolumn = {
            enable = true;
            left = [
              "mark"
              "sign"
              "git"
            ];
            right = [
              "fold"
            ];
          };
          terminal.enable = true;
        };
      };
    };
  };
}

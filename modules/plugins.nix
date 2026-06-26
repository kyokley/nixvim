{
  flake.nixvimModules.minimal = {lib, ...}: {
    plugins = {
      web-devicons.enable = true;
      vim-bbye.enable = true;
      lualine = {
        enable = true;
        settings.options.globalstatus = false;
      };
      marks.enable = true;
      indent-o-matic = {
        enable = true;
        settings = {
          max_lines = 2048;
          skip_multiline = false;
          standard_widths = [
            2
            4
            8
          ];
        };
      };
      illuminate.enable = true;
      alpha = {
        enable = true;
        theme = "startify";
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          linehl = false;
          numhl = false;
          signs = {
            add.text = "+";
            change.text = "~";
          };
        };
      };

      nvim-tree = {
        enable = true;
        autoClose = true;
      };

      telescope = {
        enable = lib.mkDefault false;
        keymaps = {
          # <leader>8 is mapped in key_maps.nix
          # <leader>a is mapped in key_maps.nix
          "<C-p>" = "git_files";
          "<leader>a" = "live_grep";
        };
      };
      treesitter.enable = lib.mkDefault false;
      cmp.enable = lib.mkDefault false;
    };
  };
}

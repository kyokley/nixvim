{
  flake.nixvimModules.full = {pkgs, ...}: {
    extraPlugins = with pkgs.vimPlugins; [
      vim-mundo
    ];

    extraConfigLua = ''
      -- Vim-Mundo {{{
      vim.g.mundo_preview_bottom = 1
      -- vim.g.mundo_close_on_revert = 1
      -- }}}
    '';

    keymaps = [
      {
        key = "<F5>";
        action = ":MundoToggle<CR>";
        mode = ["n"];
      }
    ];
  };
}

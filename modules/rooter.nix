{
  flake.nixvimModules.full = {pkgs, ...}: {
    extraPlugins = with pkgs.vimPlugins; [
      vim-rooter
    ];

    extraConfigLua = ''
      -- Rooter {{{
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_manual_only = 1
      -- }}}
    '';
  };
}

{
  flake.nixvimModules.full = {pkgs, ...}: {
    extraConfigLua = ''
      -- {{{ Vista
      vim.g.vista_highlight_whole_line = 1
      vim.g.vista_blank = {0, 0}
      vim.g.vista_top_level_blink = {0, 0}
      vim.g.vista_echo_cursor = 1
      vim.g.vista_echo_cursor_strategy = 'echo'
      vim.g.vista_cursor_delay = 1000
      vim.g.vista_fzf_preview = {}
      -- }}}
    '';

    extraPlugins = with pkgs.vimPlugins; [
      vista-vim
    ];

    keymaps = [
      {
        key = "<F4>";
        action = ":Vista!!<CR>";
        mode = ["n"];
      }
    ];
  };
}

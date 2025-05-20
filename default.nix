{
  imports = [
    ./config/bufferline.nix
    ./config/global_options.nix
    ./config/highlights.nix
    ./config/plugins/full.nix
    ./config/key_maps.nix
    ./config/functions.nix
    ./config/auto_commands.nix
    ./config/lsp.nix
  ];

  vimAlias = true;
}

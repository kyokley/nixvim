{...}:
{
    imports = [
        ./bufferline.nix
            ./lsp.nix
            ./global_options.nix
            ./highlights.nix
            ./auto_commands.nix
            ./plugins.nix
            ./key_maps.nix
            ./functions.nix
    ];

    viAlias = true;
    vimAlias = true;

}

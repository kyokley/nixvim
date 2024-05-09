{...}:
{
    imports = [
        ./bufferline.nix
            ./lsp.nix
            ./global_options.nix
            ./highlights.nix
            ./plugins.nix
            ./key_maps.nix
            ./functions.nix
            ./auto_commands.nix
    ];

    viAlias = true;
    vimAlias = true;

}

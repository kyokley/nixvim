{...}:
{
# Import all your configuration modules here
    imports = [
        ./bufferline.nix
            ./global_options.nix
            ./highlights.nix
            ./auto_commands.nix
            ./plugins.nix
            ./key_maps.nix
    ];

    viAlias = true;
    vimAlias = true;

}

{...}: {
  # Import all your configuration modules here
  imports = [
    # ./barbar.nix
    ./bufferline.nix
    ./global_options.nix
    ./highlights.nix
    ./auto_commands.nix
    ./plugins.nix
  ];

  viAlias = true;
  vimAlias = true;

}

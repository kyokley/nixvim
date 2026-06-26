{
  flake.nixvimModules.minimal = {
    pkgs,
    lib,
    ...
  }: {
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      jq
    ];

    diagnostic.settings = {
      virtual_lines = {
        current_line = true;
      };
      virtual_text = false;
    };
  };
}

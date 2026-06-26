{
  flake.nixvimModules = {
    minimal = {
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

    full = {pkgs, ...}: {
      extraPython3Packages = p:
        with p; [
          bandit
        ];

      extraPlugins = with pkgs.vimPlugins; [
        fzf-vim # Needed to use vim version to work with vista-vim
        vim-exchange
      ];
    };
  };
}

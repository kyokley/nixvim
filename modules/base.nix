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
        signs = {
          text.__raw = ''
            {
              [vim.diagnostic.severity.ERROR] = "",
              [vim.diagnostic.severity.WARN] = "",
              [vim.diagnostic.severity.INFO] = "",
              [vim.diagnostic.severity.HINT] = "",
            }
          '';
        };
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

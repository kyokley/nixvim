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

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "jj-diffconflicts";
          version = "a2aa9a2";
          src = pkgs.fetchFromGitHub {
            owner = "rafikdraoui";
            repo = "jj-diffconflicts";
            rev = "a2aa9a247b56d2c1a6f6be81bcf41c5450cc82ff";
            hash = "sha256-MjacjGlBRwActBBGeBZDHz8jz5J3Mt6KoDsf8WKgUDA=";
          };
        })
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

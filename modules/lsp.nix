{
  flake.nixvimModules = {
    full = {pkgs, ...}: {
      plugins = {
        lsp-format.enable = false;
        lsp-lines = {
          enable = true;
          autoLoad = true;
        };
        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            dockerls.enable = true;
            docker_compose_language_service.enable = true;
            nginx_language_server.enable = false;
            lua_ls.enable = true;
            ruff.enable = true;
            pylsp.enable = true;
            statix = {
              enable = true;
              autostart = true;
              filetypes = ["nix"];
            };
            nixd = {
              enable = true;
              extraOptions = {
                autoArchive = true;
              };
              settings = {
                nixpkgs = {
                  expr = "import <nixpkgs> {}";
                };
                formatting = {
                  command = ["alejandra"];
                };
                options = {
                  nixos.expr = pkgs.lib.mkDefault ''(builtins.getFlake "git+https://github.com/kyokley/dotfiles").nixosConfigurations.default.options'';
                  home-manager.expr = pkgs.lib.mkDefault ''(builtins.getFlake "git+https://github.com/kyokley/dotfiles").homeConfigurations.default.options'';
                };
              };
            };
          };
        };
      };
    };
  };
}

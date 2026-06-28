{
  flake.nixvimModules = {
    full = {
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
                  nixos.expr = ''(builtins.getFlake "git+https://github.com/kyokley/dotfiles").nixosConfigurations.mars.options'';
                  home-manager.expr = ''(builtins.getFlake "git+https://github.com/kyokley/dotfiles").homeConfigurations.mars.options'';
                };
              };
            };
          };
        };
      };
    };

    "yokley@dioxygen" = {
      plugins.lsp.servers.nixd.settings.options = {
        home-manager.expr = ''(builtins.getFlake "git+https://github.com/kyokley/dotfiles").homeConfigurations."yokley@dioxygen".options'';
      };
    };
  };
}

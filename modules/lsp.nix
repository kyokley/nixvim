{
  flake.nixvimModules.full = {
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
          nil_ls = {
            enable = true;
            extraOptions = {
              autoArchive = true;
            };
          };
          nixd = {
            enable = true;
            extraOptions = {
              autoArchive = true;
            };
            cmd = [
              "devenv"
              "lsp"
            ];
          };
        };
      };
    };
  };
}

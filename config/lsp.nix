{
  plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        nginx_language_server.enable = false;
        lua_ls.enable = true;
        ruff.enable = true;
        pylsp.enable = false;
        nil_ls = {
          enable = true;
          extraOptions = {
            autoArchive = true;
          };
        };
      };
    };
  };
}

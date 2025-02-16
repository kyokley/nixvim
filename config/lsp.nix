{
    plugins = {
        lsp = {
            enable = true;
            servers = {
                bashls.enable = true;
                dockerls.enable = true;
                docker_compose_language_service.enable = true;
                nginx_language_server.enable = true;
                lua_ls.enable = true;
                ruff.enable = true;
                pylsp.enable = true;
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

{
    plugins = {
        lsp = {
            enable = true;
            servers = {
                bashls.enable = true;
                dockerls.enable = true;
                docker-compose-language-service.enable = true;
                nginx-language-server.enable = true;
                lua-ls.enable = true;
                ruff.enable = true;
                pylsp.enable = true;
                nil_ls.enable = true;
                csharp-ls.enable = true;
            };
        };
    };
}

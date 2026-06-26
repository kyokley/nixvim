{
  flake.nixvimModules.full = {
    pkgs,
    lib,
    ...
  }: {
    opts = {
      formatexpr = "v:lua.require'conform'.formatexpr()";
    };

    plugins = {
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = ["stylua"];
            python = [
              "ruff_format"
              "ruff_organize_imports"
            ];
            nix = ["alejandra"];
            html = ["htmlbeautifier"];
            htmldjango = ["djhtml"];
            json = ["jq"];
            javascript = ["prettier"];
            bash = ["shfmt"];
            yaml = ["yamlfmt"];
          };
          formatters = {
            stylua.command = lib.getExe pkgs.stylua;
            isort.command = lib.getExe pkgs.isort;
            ruff_format.command = lib.getExe pkgs.ruff;
            ruff_organize_imports.command = lib.getExe pkgs.ruff;
            alejandra.command = lib.getExe pkgs.alejandra;
            htmlbeautifier.command = lib.getExe pkgs.rubyPackages.htmlbeautifier;
            jq.command = lib.getExe pkgs.jq;
            djhtml = {
              command = lib.getExe pkgs.djhtml;
              stdin = true;
              args = ["-"];
            };
            prettier.command = lib.getExe pkgs.prettier;
            shfmt.command = lib.getExe pkgs.shfmt;
            yamlfmt.command = lib.getExe pkgs.yamlfmt;
          };
          default_format_opts.lsp_format = "fallback";
        };
      };
    };
  };
}

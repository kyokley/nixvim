{
  flake.nixvimModules = {
    minimal = {lib, ...}: {
      plugins = {
        web-devicons.enable = true;
        vim-bbye.enable = true;
        marks.enable = true;
        indent-o-matic = {
          enable = true;
          settings = {
            max_lines = 2048;
            skip_multiline = false;
            standard_widths = [
              2
              4
              8
            ];
          };
        };
        illuminate.enable = true;
        alpha = {
          enable = true;
          theme = "startify";
        };

        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = true;
            linehl = false;
            numhl = false;
            signs = {
              add.text = "+";
              change.text = "~";
            };
          };
        };

        nvim-tree = {
          enable = true;
          autoClose = true;
        };

        lsp-progress.enable = true;
        treesitter.enable = lib.mkDefault false;
        cmp.enable = lib.mkDefault false;
      };
    };

    full = {
      pkgs,
      lib,
      ...
    }: {
      plugins = {
        numbertoggle = {
          enable = true;
        };
        colorizer.enable = true;
        treesitter = {
          enable = true;
          settings.highlight.enable = true;
        };
        rainbow-delimiters.enable = true;
        lint = {
          enable = true;
          autoCmd = {
            event = [
              "TextChanged"
              "BufWinEnter"
              "InsertLeave"
            ];
            group = "lint_setup";
          };
          linters = {
            ruff.cmd = lib.getExe pkgs.ruff;
            bandit = {
              cmd = lib.getExe' pkgs.bandit "bandit";
              args = [
                "-f"
                "custom"
                "--msg-template"
                "{line}:{col}:{severity}:{test_id} {msg}"
                "-x"
                ".svn,CVS,.bzr,.hg,.git,__pycache__,.tox,.eggs,*.egg,*/test_*.py"
              ];
            };
            hadolint.cmd = lib.getExe pkgs.hadolint;
            jsonlint.cmd = lib.getExe' pkgs.python313Packages.demjson3 "jsonlint";
            tflint.cmd = lib.getExe pkgs.tflint;
            statix.cmd = lib.getExe pkgs.statix;
          };
          lintersByFt = {
            nix = ["statix"];
            python = [
              "ruff"
              "bandit"
            ];
            dockerfile = [
              "hadolint"
            ];
            json = [
              "jsonlint"
            ];
            terraform = [
              "tflint"
            ];
          };
        };
        diffview = {
          enable = true;
          settings.enhanced_diff_hl = true;
        };
        colorful-menu.enable = true;
      };
    };
  };
}

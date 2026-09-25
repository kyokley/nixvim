{
  flake.nixvimModules.minimal = {config, ...}: {
    autoGroups = {
      general_setup.clear = true;
      terminal_setup.clear = true;
      lint_setup.clear = true;
      marks_fix_hl.clear = true;
    };

    autoCmd = [
      {
        event = ["BufReadPost"];
        pattern = "*";
        command = ''if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif'';
        group = "general_setup";
      }
      {
        event = ["BufEnter"];
        pattern = "*";
        command = ''let &titlestring = "nvim " . expand("%:p")'';
        group = "general_setup";
      }
      {
        event = ["FocusGained"];
        pattern = "*";
        command = ''checktime'';
        group = "general_setup";
      }
      {
        event = ["TermClose"];
        pattern = "<buffer>";
        command = ''if &buftype == 'terminal' | bdelete! | endif'';
        group = "general_setup";
      }
      {
        event = ["BufWritePre"];
        pattern = "*";
        command = "call RaiseExceptionForUnresolvedErrors()";
        group = "lint_setup";
      }
      {
        event = ["DiagnosticChanged"];
        pattern = "*";
        callback = {
          __raw = ''
            function(args)
              vim.diagnostic.setloclist({open = false})
            end
          '';
        };
        group = "general_setup";
      }
      {
        event = ["TermOpen"];
        pattern = "*";
        command = ''setlocal nonumber norelativenumber bufhidden=hide'';
        group = "terminal_setup";
      }
      {
        event = ["TermEnter"];
        pattern = "*";
        command = ''set timeoutlen=150'';
        group = "terminal_setup";
      }
      {
        event = ["TermLeave"];
        pattern = "*";
        command = ''set timeoutlen=${toString config.opts.timeoutlen}'';
        group = "terminal_setup";
      }
      {
        event = ["TermOpen" "BufWinEnter" "WinEnter"];
        pattern = "term://*";
        command = ''startinsert'';
        group = "terminal_setup";
      }
      {
        event = ["BufLeave"];
        pattern = "term://*";
        command = ''stopinsert'';
        group = "terminal_setup";
      }
      # When amending git commits :q can accidentally succeed if a message
      # already exists. Instead, replace :q with :cq to force vim to exit with
      # an error code.
      {
        event = ["FileType"];
        pattern = ["gitcommit"];
        command = "cnoreabbrev <buffer> <expr> q getcmdtype() == ':' && getcmdline() ==# 'q' ? 'cq' : 'q'";
      }
      {
        event = ["FileType"];
        pattern = ["git" "gitcommit"];
        command = "setlocal nospell";
      }
      {
        event = ["FileType"];
        pattern = ["git" "gitcommit"];
        command = "setlocal nolist";
      }
      {
        event = ["VimEnter"];
        pattern = "*";
        command = ''if &filetype != 'gitcommit' | match ExtraWhitespace /\s\+$\|\t/ | endif'';
      }
      {
        event = ["VimEnter"];
        pattern = "*";
        command = ''if &filetype != 'gitcommit' | highlight ExtraWhitespace ctermbg=darkred guibg=darkred ctermfg=yellow guifg=yellow | endif'';
      }
      {
        event = ["FileType"];
        pattern = ["nix"];
        command = "setlocal shiftwidth=2";
      }
      {
        event = ["FileType"];
        pattern = ["sql"];
        callback = {
          __raw = ''
            function(args)
              vim.keymap.set({"n", "x"}, "<leader>su", [[:s/\<\(desc\|trigger\|after\|for\|each\|row\|returns\|replace\|function\|execute\|procedure\|with\|case\|when\|then\|else\|end\|type\|using\|foreign\|references\|cascade\|if\|check\|coalesce\|boolean\|union\|false\|true\|integer\|text\|serial\|primary\|key\|into\|insert\|drop\|limit\|unique\|index\|default\|column\|add\|table\|create\|alter\|delete\|interval\|set\|begin\|order by\|group by\|commit\|update\|rollback\|as\|select\|distinct\|from\|null\|or\|is\|inner\|right\|outer\|join\|in\|not\|exists\|on\|where\|and\|constraint\|having\)\>\c/\U&/g<CR>]], {buffer = args.buf, silent = true, desc = "Uppercase SQL keywords"})
              vim.keymap.set({"n", "x"}, "<leader>sp", ":%!docker run --rm -i kyokley/sqlparse --keywords upper --identifiers lower --reindent -<CR>", {buffer = args.buf, silent = true, desc = "Format SQL"})
            end
          '';
        };
      }
      {
        event = ["VimEnter"];
        group = "marks_fix_hl";
        callback = {
          __raw = ''
            function(args)
              vim.api.nvim_set_hl(0, 'MarkSignNumHL', {})
            end
          '';
        };
      }
    ];
  };
}

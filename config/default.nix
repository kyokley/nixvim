{self, ...}: {
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];

  viAlias = true;
  vimAlias = true;

  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "auto";
  };

  opts = {
      "number" = true;
      "relativenumber" = true;
      "tabstop" = 8;
      "softtabstop" = 4;
      "shiftwidth" = 4;
      "expandtab" = true;
      "autoindent" = true;
      "hidden" = true;
      "autowrite" = false;
      "smarttab" = true;
      "showmatch" = true;
      "scrolloff" = 5;
      "visualbell" = true;
      "autochdir" = true;
# "wildignore" = {'*.swp', '*.bak', '*.pyc', '*.class', '*.o', '*.obj', '*.git'};
# "wildmode" = "{'longest:full', 'full'}";
      "wildmenu" = true;
      "wrapscan" = false;
      "textwidth" = 0;
      "mouse" = "";
      "autoread" = true;
      "shiftround" = true;
      "splitright" = true;
      "splitbelow" = true;
      "listchars" = "trail:_";
      "list" = true;
      "cursorline" = true;
      "incsearch" = true;
      "hlsearch" = true;
      "timeout" = true;
      "timeoutlen" = 400;
      "ttimeoutlen" = 100;
      "undofile" = true;
      "undolevels" = 1000;
      "undoreload" = 1000;
      "backup" = false;
# "diffopt" = "{'internal', 'algorithm:patience'}";
      "inccommand" = "split";
      "guicursor" = "";
      "termguicolors" = true;
  };

  highlightOverride = {
    EndOfBuffer = {
        ctermbg = null;
        bg = null;
    };
    # MatchParen.ctermbg = "4";

    Normal = {
        ctermbg = "black";
        bg = "black";
    };
    NormalNC = {
        ctermbg = "black";
        bg = "black";
    };
    NonText = {
        ctermbg = null;
        bg = null;
    };

    CursorLine = {
        ctermbg = "darkblue";
        ctermfg = "white";
        bg = "darkblue";
        fg = "white";
    };

    ColorColumn = {
        ctermbg = "black";
        bg = "black";
    };

    TabLineFill = {
        cterm = null;
        ctermbg = null;
        bg = null;
    };

    TabLine = {
        cterm = null;
        ctermbg = null;
        bg = null;
    };

    search = {
        cterm = null;
        ctermbg = "lightblue";
        ctermfg = "black";
        bg = "lightblue";
        fg = "black";
    };

    signcolumn = {
        cterm = null;
        ctermbg = "black";
        bg = "black";
    };
    visual = {
        cterm = null;
        ctermbg = "darkgrey";
        bg = "darkgrey";
        # ctermfg = "black";
    };

     statusline ={
         cterm = null;
         # ctermbg = "4";
         ctermfg = "white";
     };

  };

  match = {
    ErrorMsg = ''^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'';
  };

  keymaps = [
    {
        key = "<leader>c";
        action = ":set cursorline!<CR>";
        options = {silent = true;};
    }
    {
        key = "<up>";
        action = "<nop>";
        mode = ["n" "i"];
    }
    {
        key = "<down>";
        action = "<nop>";
        mode = ["n" "i"];
    }
    {
        key = "<left>";
        action = "<nop>";
        mode = ["n" "i"];
    }
    {
        key = "<right>";
        action = "<nop>";
        mode = ["n" "i"];
    }
    {
        key = "jj";
        action = "<Esc>";
        mode = ["i"];
    }
    {
        key = "kk";
        action = "<Esc>";
        mode = ["i"];
    }
    {
        key = "JJ";
        action = "<Esc>";
        mode = ["i"];
    }
    {
        key = "KK";
        action = "<Esc>";
        mode = ["i"];
    }
    {
        key = "M";
        action = ":join<CR>";
        mode = ["n" "x"];
    }
    {
        key = "gM";
        action = ":join!<CR>";
        mode = ["n" "x"];
    }
    {
        key = "<S-j>";
        action = ''@="20j"<CR>'';
        mode = ["n" "x"];
        options = {silent = true;};
    }
    {
        key = "<S-k>";
        action = ''@="20k"<CR>'';
        mode = ["n" "x"];
        options = {silent = true;};
    }
    {
        key = "<S-l>";
        action = "5l";
        mode = ["x"];
        options = {silent = true;};
    }
    {
        key = "<S-h>";
        action = "5h";
        mode = ["x"];
        options = {silent = true;};
    }
    {
        key = "<S-y>";
        action = "y$";
        mode = ["n"];
        options = {silent = true;};
    }
    {
        key = "<S-h>";
        action = ":bprev<CR>";
        mode = ["n"];
        options = {silent = true;};
    }
    {
        key = "<S-l>";
        action = ":bnext<CR>";
        mode = ["n"];
        options = {silent = true;};
    }
    {
        key = "<leader>h";
        action = ":nohlsearch<CR>";
        options = {silent = true;};
    }
    {
        key = "<C-j>";
        action = "<C-w>j";
        mode = ["n"];
    }
    {
        key = "<C-k>";
        action = "<C-w>k";
        mode = ["n"];
    }
    {
        key = "<C-l>";
        action = "<C-w>l";
        mode = ["n"];
    }
    {
        key = "<C-h>";
        action = "<C-w>h";
        mode = ["n"];
    }
    {
        key = "<leader>gb";
        action = '':<C-U>tabnew | terminal git blame <C-R>=expand("%:p") <CR> | color_git_blame | less +<C-R>=max([0, line('.') - winline()]) <CR><CR><CR>'';
        mode = ["n"];
    }
    {
        key = "<leader>gb";
        action = '':<C-U>tabnew | terminal git blame <C-R>=expand("%:p") <CR> | sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p | color_git_blame | less <CR><CR>'';
        mode = ["v"];
    }
    {
        key = "<leader>gl";
        action = '':<C-U>tabnew | terminal git blame <C-R>=expand("%:p") <CR> | sed -n <C-R>=line(".") <CR>p | awk '{print $1}' | tr -d '^' | xargs git show <CR><CR>'';
        mode = ["n"];
    }
    {
        key = "<F3>";
        action = ":NvimTreeToggle<CR>";
        mode = ["n"];
    }
    {
        key = "<F5>";
        action = ":UndotreeToggle<CR>";
        mode = ["n"];
    }
  ];

  autoGroups = {
    general_setup.clear = true;
    terminal_setup.clear = true;
  };

  autoCmd = [
    {
      event = ["InsertEnter"];
      pattern = "*";
      command = ''if &buftype != 'nofile' | highlight LineNr ctermbg=darkred guibg=darkred | endif'';
      group = "general_setup";
    }
    {
      event = ["InsertEnter"];
      pattern = "*";
      command = ''if &buftype != 'nofile' && &buftype != 'prompt' | highlight CursorLine ctermbg=darkred guibg=darkred | endif'';
      group = "general_setup";
    }
    {
        event = ["InsertEnter"];
        pattern = "*";
        command = ''if &buftype != 'nofile' | highlight statusline ctermbg=darkred guibg=darkred | endif'';
        group = "general_setup";
    }
    {
      event = ["InsertLeave"];
      pattern = "*";
      command = ''if &buftype != 'nofile' | highlight LineNr ctermbg=NONE guibg=NONE | endif'';
      group = "general_setup";
    }
    {
      event = ["InsertLeave"];
      pattern = "*";
      command = ''if &buftype != 'nofile' && &buftype != 'prompt' | highlight CursorLine ctermbg=darkblue guibg=darkblue | endif'';
      group = "general_setup";
    }
    {
      event = ["InsertLeave"];
      pattern = "*";
      command = ''if &buftype != 'nofile' | highlight statusline ctermbg=darkblue guibg=darkblue | endif'';
      group = "general_setup";
    }
    {
      event = ["BufReadPost"];
      pattern = "*";
      command = ''if line("'\\\"") > 0|if line("'\\\"") <= line("$")|exe("norm '\\\"")|else|exe "norm $"|endif|endif'';
      group = "general_setup";
    }
    {
      event = ["VimEnter"];
      pattern = "*";
      command = ''if &filetype != 'gitcommit' | highlight ExtraWhitespace ctermbg=darkred ctermfg=yellow guibg=darkred guifg=yellow | endif'';
      group = "general_setup";
    }
    {
      event = ["VimEnter"];
      pattern = "*";
      command = ''if &filetype != 'gitcommit' | match ExtraWhitespace /\\s\\+$\\|\\t/ | endif'';
      group = "general_setup";
    }
    {
      event = ["BufEnter"];
      pattern = "*";
      command = ''let &titlestring = "nvim " . expand("%:p")'';
      group = "general_setup";
    }
    {
      event = ["FocusGained" "VimEnter" "WinEnter" "BufWinEnter"];
      pattern = "*";
      command = ''setlocal cursorline'';
      group = "general_setup";
    }
    {
      event = ["FocusLost" "WinLeave"];
      pattern = "*";
      command = ''setlocal nocursorline'';
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
      event = ["TermOpen"];
      pattern = "*";
      command = ''setlocal nonumber norelativenumber bufhidden=hide'';
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
  ];

  plugins = {
    lualine.enable = true;
    undotree.enable = true;
    marks.enable = true;
    indent-o-matic.enable = true;

    nvim-tree = {
        enable = true;
    };
    telescope = {
        enable = true;
        keymaps = {
            "<C-p>" = "git_files";
            "<leader>8" = "grep_string";
            "<leader>a" = "live_grep";
        };
    };
    treesitter.enable = true;

    lsp = {
      enable = true;
      servers = {
        lua-ls.enable = true;
        ruff-lsp.enable = true;
      };
    };
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];

      settings.mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = ''
            cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          {"i", "s"})
          '';
        "<S-Tab>" = ''
            cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          {"i", "s"})
          '';
        };
      };
    };
}

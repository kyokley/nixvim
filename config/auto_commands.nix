{
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
      command = ''if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif'';
      group = "general_setup";
    }
    {
      event = ["BufEnter"];
      pattern = "*";
      command = "match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'";
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
        event = ["BufWritePre"];
        pattern = "*";
        command = "call RaiseExceptionForUnresolvedErrors()";
    }
    {
        event = ["FileType"];
        pattern = ["vista" "vista_kind"];
        command = "nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<CR>";
    }
    {
      event = ["BufEnter"];
      pattern = "*";
      command = "normal zx zR";
    }
    {
      event = ["DiagnosticChanged"];
      pattern = "*";
      callback = { __raw = ''
      function(args)
        vim.diagnostic.setloclist({open = false})
      end
      ''; };
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
    # When amending git commits :q can accidentally succeed if a message
    # already exists. Instead, replace :q with :cq to force vim to exit with
    # an error code.
    {
        event = ["FileType"];
        pattern = ["gitcommit"];
        command = "cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline()[0] == 'q' ? 'cq' : 'q'";
    }

    # I wanted to apply the following during the BufReadPost event but that
    # didn't seem to work. For now fall back to CursorHold.
    {
      event = ["CursorHold"];
      pattern = "*";
      command = ''match ExtraWhitespace /\s\+$\|\t/'';
      group = "general_setup";
    }
  ];
}

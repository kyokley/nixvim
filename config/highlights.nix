{
  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "auto";
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

    BufferDefaultCurrent = {
        cterm = null;
        ctermbg = "darkblue";
        bg = "darkblue";
        fg = "white";
    };

    BufferDefaultCurrentIndex = {
        cterm = null;
        ctermbg = "darkblue";
        bg = "darkblue";
        fg = "white";
    };

    BufferDefaultCurrentSign = {
        cterm = null;
        ctermbg = "black";
        bg = "black";
        fg = "darkblue";
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
    };

    statusline = {
      cterm = null;
      ctermfg = "white";
    };
  };

  match = {
    ErrorMsg = ''^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'';
  };
}

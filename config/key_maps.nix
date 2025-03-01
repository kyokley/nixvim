{
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
      action = '':<C-U>tabnew | terminal git blame <C-R>=expand("%:p") <CR> | docker run --rm -i kyokley/color_blame color_git_blame | less +<C-R>=max([0, line('.') - winline()]) <CR><CR><CR>'';
      mode = ["n"];
    }
    {
      key = "<leader>gb";
      action = '':<C-U>tabnew | terminal git blame <C-R>=expand("%:p") <CR> | sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p | docker run --rm -i kyokley/color_blame color_git_blame | less <CR><CR>'';
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
      key = "<F4>";
      action = ":Vista!!<CR>";
      mode = ["n"];
    }
    {
      key = "<F5>";
      action = ":MundoToggle<CR>";
      mode = ["n"];
    }
    {
      key = "<F12>";
      action = ":py3 SetBreakpoint()<CR>";
      mode = ["n"];
    }
    {
      key = "<S-F12>";
      action = ":py3 RemoveBreakpoints()<CR>";
      mode = ["n"];
    }
    {
      key = "<F24>";
      action = ":py3 RemoveBreakpoints()<CR>";
      mode = ["n"];
    }
    {
      key = "<leader>s";
      action = ":s/\\<\\(desc\\|trigger\\|after\\|for\\|each\\|row\\|returns\\|replace\\|function\\|execute\\|procedure\\|with\\|case\\|when\\|then\\|else\\|end\\|type\\|using\\|foreign\\|references\\|cascade\\|if\\|check\\|coalesce\\|boolean\\|union\\|false\\|true\\|integer\\|text\\|serial\\|primary\\|key\\|into\\|insert\\|drop\\|limit\\|unique\\|index\\|default\\|column\\|add\\|table\\|create\\|alter\\|delete\\|interval\\|set\\|begin\\|order by\\|group by\\|commit\\|update\\|rollback\\|as\\|select\\|distinct\\|from\\|null\\|or\\|is\\|inner\\|right\\|outer\\|join\\|in\\|not\\|exists\\|on\\|where\\|and\\|constraint\\|having\\)\\>\\c/\\U&/g<CR>";
      mode = ["n" "x"];
      options = {silent = true;};
    }
    {
      key = "<leader>sp";
      action = ":%!docker run --rm -i kyokley/sqlparse --keywords upper --identifiers lower --reindent -<CR>";
      mode = ["n" "x"];
      options = {silent = true;};
    }

    {
      key = "ii";
      action = ":<c-u>call InIndentation()<cr>";
      mode = ["o" "x"];
    }
    {
      key = "ai";
      action = ":<c-u>call AroundIndentation()<cr>";
      mode = ["o" "x"];
    }
    {
      key = ",#";
      action = ":call CommentLineToEnd('# ')<CR>+";
      mode = ["n" "x"];
    }
    {
      key = ",*";
      action = ":call CommentLinePincer('/* ', ' */')<CR>+";
      mode = ["n" "x"];
    }
    {
      key = ",-";
      action = ":call CommentLinePincer('<!-- ', ' -->')<CR>+";
      mode = ["n" "x"];
    }
    {
      key = "<leader>8";
      action.__raw = ''
        function()
            local telescope = require('telescope.builtin')
            telescope.grep_string({theme = 'dropdown', cwd=vim.fn['FindRootDirectory']() ~= "" and vim.fn['FindRootDirectory']() or vim.fn.getcwd()})
        end
      '';
    }
    {
      key = "<leader>a";
      action.__raw = ''
        function()
            local telescope = require('telescope.builtin')
            telescope.live_grep({theme = 'dropdown', cwd=vim.fn['FindRootDirectory']() ~= "" and vim.fn['FindRootDirectory']() or vim.fn.getcwd()})
        end
      '';
    }
    {
      key = "<leader>to";
      action.__raw = ''
        function()
            vim.opt.scrolloff = 999 - vim.o.scrolloff
        end
      '';
    }
  ];
}

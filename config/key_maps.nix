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
        key = "<F4>";
        action = ":Vista!!<CR>";
        mode = ["n"];
    }
    {
        key = "<F5>";
        action = ":UndotreeToggle<CR>";
        mode = ["n"];
    }
  ];
}

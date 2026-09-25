{
  flake.nixvimModules.minimal = {
    keymaps = [
      {
        key = "<leader>tc";
        action = ":set cursorline!<CR>";
        options = {
          silent = true;
          desc = "Toggle cursor line";
        };
      }
      {
        key = "<up>";
        action = "<nop>";
        mode = ["n" "i"];
        options.desc = "Disable Up arrow";
      }
      {
        key = "<down>";
        action = "<nop>";
        mode = ["n" "i"];
        options.desc = "Disable Down arrow";
      }
      {
        key = "<left>";
        action = "<nop>";
        mode = ["n" "i"];
        options.desc = "Disable Left arrow";
      }
      {
        key = "<right>";
        action = "<nop>";
        mode = ["n" "i"];
        options.desc = "Disable Right arrow";
      }
      {
        key = "jj";
        action = "<Esc>";
        mode = ["i"];
        options.desc = "Exit insert mode";
      }
      {
        key = "kk";
        action = "<Esc>";
        mode = ["i"];
        options.desc = "Exit insert mode";
      }
      {
        key = "JJ";
        action = "<Esc>";
        mode = ["i"];
        options.desc = "Exit insert mode";
      }
      {
        key = "KK";
        action = "<Esc>";
        mode = ["i"];
        options.desc = "Exit insert mode";
      }
      {
        key = "M";
        action = ":join<CR>";
        mode = ["n" "x"];
        options.desc = "Join lines";
      }
      {
        key = "gM";
        action = ":join!<CR>";
        mode = ["n" "x"];
        options.desc = "Join lines without space";
      }
      {
        key = "<S-j>";
        action = ''@="20j"<CR>'';
        mode = ["n" "x"];
        options = {
          silent = true;
          desc = "Move down 20 lines";
        };
      }
      {
        key = "<S-k>";
        action = ''@="20k"<CR>'';
        mode = ["n" "x"];
        options = {
          silent = true;
          desc = "Move up 20 lines";
        };
      }
      {
        key = "<S-l>";
        action = "5l";
        mode = ["x"];
        options = {
          silent = true;
          desc = "Move right 5 columns";
        };
      }
      {
        key = "<S-h>";
        action = "5h";
        mode = ["x"];
        options = {
          silent = true;
          desc = "Move left 5 columns";
        };
      }
      {
        key = "<S-y>";
        action = "y$";
        mode = ["n"];
        options = {
          silent = true;
          desc = "Yank to line end";
        };
      }
      {
        key = "<S-h>";
        action = ":bprev<CR>";
        mode = ["n"];
        options = {
          silent = true;
          desc = "Previous buffer";
        };
      }
      {
        key = "<S-l>";
        action = ":bnext<CR>";
        mode = ["n"];
        options = {
          silent = true;
          desc = "Next buffer";
        };
      }
      {
        key = "<leader>h";
        action = ":nohlsearch<CR>";
        options = {
          silent = true;
          desc = "Clear search highlight";
        };
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        mode = ["n"];
        options.desc = "Focus window below";
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
        mode = ["n"];
        options.desc = "Focus window above";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        mode = ["n"];
        options.desc = "Focus window right";
      }
      {
        key = "<C-h>";
        action = "<C-w>h";
        mode = ["n"];
        options.desc = "Focus window left";
      }
      {
        key = "<leader>gb";
        action.__raw = ''
          function()
              local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
              local line = vim.fn.line(".")
              local less_line = math.max(0, line - vim.fn.winline())
              if filename == "" then
                  vim.notify("Cannot blame unnamed buffer", vim.log.levels.ERROR)
                  return
              end

              local root = vim.fn.systemlist({"git", "-C", vim.fn.fnamemodify(filename, ":h"), "rev-parse", "--show-toplevel"})[1]
              if vim.v.shell_error ~= 0 or not root or root == "" then
                  vim.notify("Cannot find Git repository for " .. filename, vim.log.levels.ERROR)
                  return
              end

              local command = "git -C " .. vim.fn.shellescape(root)
                  .. " blame -- " .. vim.fn.shellescape(filename)
                  .. " | docker run --rm -i kyokley/color_blame color_git_blame | less "
                  .. vim.fn.shellescape("+" .. less_line)
              vim.cmd.tabnew()
              local job_id = vim.fn.termopen({vim.o.shell, vim.o.shellcmdflag, command})
              if job_id <= 0 then
                  vim.notify("Could not open terminal", vim.log.levels.ERROR)
                  return
              end
          end
        '';
        mode = ["n"];
        options.desc = "Blame file";
      }
      {
        key = "<leader>gb";
        action.__raw = ''
          function()
              local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
              local first = vim.fn.line("'<")
              local last = vim.fn.line("'>")
              if first > last then
                  first, last = last, first
              end
              if filename == "" then
                  vim.notify("Cannot blame unnamed buffer", vim.log.levels.ERROR)
                  return
              end

              local root = vim.fn.systemlist({"git", "-C", vim.fn.fnamemodify(filename, ":h"), "rev-parse", "--show-toplevel"})[1]
              if vim.v.shell_error ~= 0 or not root or root == "" then
                  vim.notify("Cannot find Git repository for " .. filename, vim.log.levels.ERROR)
                  return
              end

              local command = "git -C " .. vim.fn.shellescape(root)
                  .. " blame -L " .. vim.fn.shellescape(string.format("%d,%d", first, last))
                  .. " -- " .. vim.fn.shellescape(filename)
                  .. " | docker run --rm -i kyokley/color_blame color_git_blame | less"
              vim.cmd.tabnew()
              local job_id = vim.fn.termopen({vim.o.shell, vim.o.shellcmdflag, command})
              if job_id <= 0 then
                  vim.notify("Could not open terminal", vim.log.levels.ERROR)
                  return
              end
          end
        '';
        mode = ["v"];
        options.desc = "Blame selection";
      }
      {
        key = "<leader>gl";
        action.__raw = ''
          function()
              local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
              local line = vim.fn.line(".")
              if filename == "" then
                  vim.notify("Cannot show commit for unnamed buffer", vim.log.levels.ERROR)
                  return
              end

              local root = vim.fn.systemlist({"git", "-C", vim.fn.fnamemodify(filename, ":h"), "rev-parse", "--show-toplevel"})[1]
              if vim.v.shell_error ~= 0 or not root or root == "" then
                  vim.notify("Cannot find Git repository for " .. filename, vim.log.levels.ERROR)
                  return
              end

              local porcelain = vim.fn.systemlist({"git", "-C", root, "blame", "--porcelain", "-L", string.format("%d,%d", line, line), "--", filename})
              if vim.v.shell_error ~= 0 then
                  vim.notify("git blame failed", vim.log.levels.ERROR)
                  return
              end
              local hash = porcelain[1] and porcelain[1]:match("%^?([0-9a-fA-F]+)%s")
              if not hash or (#hash ~= 40 and #hash ~= 64) then
                  vim.notify("Could not determine commit for current line", vim.log.levels.ERROR)
                  return
              end

              vim.cmd.tabnew()
              local job_id = vim.fn.termopen({"git", "-C", root, "show", hash})
              if job_id <= 0 then
                  vim.notify("Could not open terminal", vim.log.levels.ERROR)
              end
          end
        '';
        mode = ["n"];
        options.desc = "Show line commit";
      }
      {
        key = "<F3>";
        action = ":NvimTreeToggle<CR>";
        mode = ["n"];
        options.desc = "Toggle file tree";
      }
      {
        key = "<F12>";
        action = ":py3 SetBreakpoint()<CR>";
        mode = ["n"];
        options.desc = "Set Python breakpoint";
      }
      {
        key = "<S-F12>";
        action = ":py3 RemoveBreakpoints()<CR>";
        mode = ["n"];
        options.desc = "Remove Python breakpoints";
      }
      {
        key = "<F24>";
        action = ":py3 RemoveBreakpoints()<CR>";
        mode = ["n"];
        options.desc = "Remove Python breakpoints";
      }
      {
        key = "ii";
        action = ":<c-u>call InIndentation()<cr>";
        mode = ["o" "x"];
        options.desc = "Inner indentation";
      }
      {
        key = "ai";
        action = ":<c-u>call AroundIndentation()<cr>";
        mode = ["o" "x"];
        options.desc = "Around indentation";
      }
      {
        key = ",#";
        action = ":call CommentLineToEnd('# ')<CR>+";
        mode = ["n" "x"];
        options.desc = "Comment with hash";
      }
      {
        key = ",*";
        action = ":call CommentLinePincer('/* ', ' */')<CR>+";
        mode = ["n" "x"];
        options.desc = "Comment with block comment";
      }
      {
        key = ",-";
        action = ":call CommentLinePincer('<!-- ', ' -->')<CR>+";
        mode = ["n" "x"];
        options.desc = "Comment with HTML comment";
      }
      {
        key = "<leader>to";
        action.__raw = ''
          function()
              vim.opt.scrolloff = 999 - vim.o.scrolloff
          end
        '';
        options.desc = "Toggle scroll offset";
      }
    ];
  };
}

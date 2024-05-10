{pkgs, lib, ...}:
let
fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
    };
};
in
{
    extraPython3Packages = p: with p; [
        bandit
    ];

    plugins = {
        lualine.enable = true;
        undotree.enable = true;
        marks.enable = true;
        indent-o-matic.enable = true;
        rainbow-delimiters.enable = true;
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

        telescope = {
            enable = true;
            keymaps = {
                "<C-p>" = "git_files";
                "<leader>8" = "grep_string";
                "<leader>a" = "live_grep";
            };
        };
        treesitter.enable = true;

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

    extraPlugins = with pkgs.vimPlugins; [
        (fromGitHub "32929480b1753a5c2a99435e891da9be1e61e0b9" "main" "willothy/nvim-cokeline")
        (fromGitHub "04fa99afe865b16324af94fd8a8391121117d8f7" "master" "liuchengxu/vista.vim")
        (fromGitHub "d6c1e9790bcb8df27c483a37167459bbebe0112e" "master" "tommcdo/vim-exchange")
        (fromGitHub "bcda25a513abc2d4744bc1f8c910eaae305a5242" "master" "junegunn/fzf")
        (fromGitHub "2ca2a8657672e121a5afae87b9d152eeb3726519" "master" "jlcrochet/vim-razor")
    ];

    extraConfigLua = ''
        -- Cokeline Bufferline Config {{{
            local get_hex = require('cokeline/utils').get_hex

                local red = 'red'
                local yellow = 'yellow'
                local orange = 'orange'
                local blue = "darkblue"
                local green = "green"

                local components = {
                    space = { text = ' ' , bg = 'none'},
                    left_cap = {
                        text = function(buffer) return buffer.is_focused and '' or ' ' end,
                        fg = function(buffer)
                            return buffer.is_focused and blue or 'none'
                            end,
                        bg = 'none',
                    },
                    devicon = {
                        text = function(buffer) return buffer.devicon.icon .. ' ' end,
                        fg = function(buffer) return buffer.devicon.color end,
                    },
                    index = {
                        text = function(buffer) return buffer.number .. ': ' end,
                    },
                    prefix = {
                        text = function(buffer) return buffer.unique_prefix end,
                        fg = function(buffer)
                            return buffer.is_modified and orange or nil
                            end,
                        style = 'italic',
                    },
                    filename = {
                        text = function(buffer)
                            return buffer.filename
                            end,
                        fg = function(buffer)
                            return buffer.is_modified and orange or nil
                            end,
                        style = function(buffer)
                            if buffer.is_focused then
                                return "bold"
                                    end
                                    return nil
                                    end
                    },
                    readonly = {
                        text = function(buffer)
                            if buffer.is_readonly then
                                return " 🔒"
                                    end
                                    return ""
                                    end
                    },
                    unsaved = {
                        text = function(buffer)
                            return buffer.is_modified and ' ●' or '  '
                            end,
                        fg = function(buffer)
                            return buffer.is_modified and "#e5c463" or nil
                            end,
                        truncation = { priority = 1 },
                    },
                    right_cap = {
                        text = function(buffer) return buffer.is_focused and '' or ' ' end,
                        fg = function(buffer)
                            return buffer.is_focused and blue or 'none'
                            end,
                        bg = 'none',
                    },
                    diagnostic_errors = {
                        text = function(buffer)
                            return
                            (buffer.diagnostics.errors ~= 0 and ' 󰅚 ' .. buffer.diagnostics.errors)
                            or ""
                            end,
                        fg = function(buffer)
                            return
                            (buffer.diagnostics.errors ~= 0 and red)
                            or nil
                            end,
                        truncation = { priority = 1 },
                    },
                    diagnostic_warnings = {
                        text = function(buffer)
                            return
                            (buffer.diagnostics.warnings ~= 0 and ' 󰀪 ' .. buffer.diagnostics.warnings)
                            or ""
                            end,
                        fg = function(buffer)
                            return
                            (buffer.diagnostics.warnings ~= 0 and yellow)
                            or nil
                            end,
                        truncation = { priority = 1 },
                    },
                }

            require('cokeline').setup({
                    default_hl = {
                    fg = function(buffer)
                    -- return buffer.is_focused and get_hex('Normal', 'fg') or 'none'
                    return buffer.is_focused and 'none'
                    end,
                    bg = function(buffer)
                    return buffer.is_focused and blue or 'none'
                    end,
                    },

                    components = {
                    components.space,
                    components.left_cap,
                    components.devicon,
                    components.index,
                    components.prefix,
                    components.filename,
                    components.diagnostic_errors,
                    components.diagnostic_warnings,
                    components.readonly,
                    -- components.unsaved,
                    components.right_cap,
                    },
            })
            -- }}}

            -- {{{ Vista
            vim.g.vista_highlight_whole_line = 1
            vim.g.vista_blank = {0, 0}
            vim.g.vista_top_level_blink = {0, 0}
            vim.g.vista_echo_cursor = 1
            vim.g.vista_echo_cursor_strategy = 'floating_win'
            vim.g.vista_cursor_delay = 1000
            vim.g.vista_fzf_preview = {}
            -- }}}

        '';
}

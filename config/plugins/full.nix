{ pkgs, lib, ... }:
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
    imports = [
        ./minimal.nix
    ];

    extraPython3Packages = p: with p; [
        bandit
    ];

    plugins = {
        oil.enable = true;
        treesitter.enable = true;
        telescope.enable = true;
        rainbow-delimiters.enable = true;
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

    extraPlugins = [
        (fromGitHub "04fa99afe865b16324af94fd8a8391121117d8f7" "master" "liuchengxu/vista.vim")
        (fromGitHub "2ca2a8657672e121a5afae87b9d152eeb3726519" "master" "jlcrochet/vim-razor")
        (fromGitHub "bcda25a513abc2d4744bc1f8c910eaae305a5242" "master" "junegunn/fzf")
        (fromGitHub "2ceda8c65f7b3f9066820729fc02003a09df91f9" "master" "simnalamburt/vim-mundo")
        (fromGitHub "d6c1e9790bcb8df27c483a37167459bbebe0112e" "master" "tommcdo/vim-exchange")
        (fromGitHub "45e53f01e4e1c4a3ee20814de232162713aff578" "master" "airblade/vim-rooter")
    ];

    extraConfigLua = ''
            -- {{{ Vista
            vim.g.vista_highlight_whole_line = 1
            vim.g.vista_blank = {0, 0}
            vim.g.vista_top_level_blink = {0, 0}
            vim.g.vista_echo_cursor = 1
            vim.g.vista_echo_cursor_strategy = 'floating_win'
            vim.g.vista_cursor_delay = 1000
            vim.g.vista_fzf_preview = {}
            -- }}}

            -- Rooter {{{
            vim.g.rooter_silent_chdir = 1
            vim.g.rooter_manual_only = 1
            -- }}}

            -- Vim-Mundo {{{
            vim.g.mundo_preview_bottom = 1
            -- vim.g.mundo_close_on_revert = 1
            -- }}}
    '';
}

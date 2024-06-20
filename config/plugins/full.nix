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
    ];
}

{
  flake.nixvimModules.full = {
    plugins = {
      blink-cmp = {
        enable = false;
        settings = {
          appearance = {
            nerd_font_variant = "normal";
            use_nvim_cmp_as_default = true;
          };
          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
                semantic_token_resolution = {
                  enabled = false;
                };
              };
            };
            documentation = {
              auto_show = true;
            };
            menu = {
              auto_show = true;
              draw = {
                # columns = {
                #   "kind_icon" = {
                #     kind = { };
                #   };

                #   "label" = {
                #     gap = 1;
                #   };
                # };
                components = {
                  label = {
                    text.__raw = ''
                      function(ctx)
                          return require("colorful-menu").blink_components_text(ctx)
                      end
                    '';
                    highlight.__raw = ''
                      function(ctx)
                          return require("colorful-menu").blink_components_highlight(ctx)
                      end
                    '';
                  };
                };
              };
            };
          };
          keymap = {
            preset = "super-tab";
          };
          signature = {
            enabled = true;
          };
          sources = {
            default = [
              "lsp"
              "buffer"
            ];
            per_filetype = {
              opencode_ask = [
                "lsp"
                "buffer"
              ];
            };
            cmdline = [];
            providers = {
              buffer = {
                score_offset = -7;
              };
              lsp = {
                fallbacks = [];
              };
            };
          };
        };
      };
    };
  };
}

{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        minimalNixvimModule = {
          inherit pkgs;
          module = ./minimal.nix;
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };
        minimalNvim = nixvim'.makeNixvimWithModule minimalNixvimModule;

        nvim = minimalNvim.extend {imports = [./config/plugins/full.nix];};

        nvimWithAider = nvim.extend {imports = [./config/plugins/aider.nix];};

        dosNvim = nvim.extend {imports = [./dos.nix];};

        devShell = let
          nvim = nixvim.legacyPackages.x86_64-linux.makeNixvim {
            plugins = {
              alpha = {
                enable = true;
                theme = "dashboard";
              };
            };
            extraPlugins = [
              # (pkgs.vimUtils.buildVimPlugin {
              #   name = "nvim-aider";
              #   src = pkgs.fetchFromGitHub {
              #     owner = "GeorgesAlkhouri";
              #     repo = "nvim-aider";
              #     rev = "main";
              #     hash = "sha256-LHSDfn9I+Ff83u8DZlom7fgZNwqSZ1h72y6NJq0eKTw=";
              #   };
              #   doCheck = false;
              # })
            ];
            extraConfigLua = ''
              local alpha = require("alpha")
              local dashboard = require("alpha.themes.dashboard")
              local uv = vim.loop

              local function animated_header(frames, interval)
                local header = {
                  type = "text",
                  val = frames[1],
                  opts = { position = "center", hl = "Type" },
                }

                local timer = uv.new_timer()
                local i = 1

                timer:start(
                  interval,
                  interval,
                  vim.schedule_wrap(function()
                    if not header.val then
                      timer:stop()
                      timer:close()
                      return
                    end
                    i = (i % #frames) + 1
                    header.val = frames[i]
                    alpha.redraw()
                  end)
                )

                return header
              end

              local boot_frames = {
                {
                  "╭──────────────────────────╮",
                  "│    booting nvim…        │",
                  "╰──────────────────────────╯",
                },
                {
                  "╭──────────────────────────╮",
                  "│    loading plugins…     │",
                  "╰──────────────────────────╯",
                },
                {
                  "╭──────────────────────────╮",
                  "│    attaching LSP…       │",
                  "╰──────────────────────────╯",
                },
                {
                  "╭──────────────────────────╮",
                  "│  ✔  ready                │",
                  "╰──────────────────────────╯",
                },
              }

              dashboard.section.header = animated_header(boot_frames, 500)

              alpha.setup({
                layout = {
                  { type = "padding", val = 2 },
                  dashboard.section.header,
                  { type = "padding", val = 2 },
                  dashboard.section.buttons,
                  dashboard.section.footer,
                },
              })

            '';
          };
        in
          pkgs.mkShell {
            buildInputs = [nvim];
          };
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "default test";
          };
          minimal = nixvimLib.check.mkTestDerivationFromNvim {
            nvim = minimalNvim;
            name = "minimal test";
          };
          dos = nixvimLib.check.mkTestDerivationFromNvim {
            nvim = dosNvim;
            name = "dos test";
          };
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          withAider = nvimWithAider;
          minimal = minimalNvim;
          dos = dosNvim;
          docker-image = pkgs.dockerTools.buildImage {
            name = "kyokley/nixvim";
            tag = "latest";
            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              paths = [nvim];
              pathsToLink = ["/bin"];
            };
            config = {
              Entrypoint = ["/bin/vim"];
            };
          };
        };
        devShells.default = devShell;
      };
    };
}

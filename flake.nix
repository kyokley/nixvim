{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    copilot-cmp = {
      url = "github:kyokley/copilot-cmp";
      flake = false;
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
          module = ./minimal.nix;
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit inputs;
            # inherit (inputs) foo;
          };
        };
        minimalNvim = nixvim'.makeNixvimWithModule minimalNixvimModule;

        nvimWithoutCopilot = minimalNvim.extend {imports = [./config/plugins/full.nix];};

        nvim = nvimWithoutCopilot.extend {
          imports = [
            ./config/plugins/copilot.nix
          ];
        };

        dosNvim = nvim.extend {imports = [./dos.nix];};

        devShell = let
          nvim = nixvim.legacyPackages.x86_64-linux.makeNixvim {
            plugins = {
            };
            extraPlugins = [
            ];
          };
        in
          pkgs.mkShell {
            buildInputs = [nvim pkgs.lsof];
          };
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
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
          withoutCopilot = nvimWithoutCopilot;
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

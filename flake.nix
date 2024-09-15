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
        };
        minimalNvim = nixvim'.makeNixvimWithModule minimalNixvimModule;

        nixvimModule = {
          inherit pkgs;
          module = ./default.nix;
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;

        dosNixvimModule = {
          inherit pkgs;
          module = ./dos.nix;
        };
        dosNvim = nixvim'.makeNixvimWithModule dosNixvimModule;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          minimal = nixvimLib.check.mkTestDerivationFromNixvimModule minimalNixvimModule;
          dos = nixvimLib.check.mkTestDerivationFromNixvimModule dosNixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          minimal = minimalNvim;
          dos = dosNvim;
        };
      };
    };
}

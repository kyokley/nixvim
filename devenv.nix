{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  # https://devenv.sh/basics/
  env.GREET = "Nixvim";

  # https://devenv.sh/packages/
  packages = [
    pkgs.docker
  ];

  # https://devenv.sh/languages/
  # languages.lua.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    hello.exec = ''
      echo Welcome to
      echo $GREET | ${pkgs.figlet}/bin/figlet -f slant | ${pkgs.lolcat}/bin/lolcat
    '';
    build-docker.exec = ''
      docker build -t kyokley/nixvim --network=host .
    '';
  };

  enterShell = ''
    hello
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.alejandra.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}

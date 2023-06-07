{
  description =
    "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = { self, ... }@inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description =
          "Pympler is a development tool to measure, monitor and analyze the memory behavior of Python objects in a running Python application.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pympler/pympler";
        maintainers = with pkgs.lib.maintainers; [ ];
        shellHook-for = { package, python }: ''
          export PNAME="${package.pname}";
          export PVERSION="${package.version}";
          export PYVERSION="${python.name}";
          export PS1="\033[37m[\[\033[01;33m\]\$PNAME-\$PVERSION\033[01;37m|\033[01;32m\]\$PYVERSION\]\033[37m|\[\033[00m\]\[\033[01;34m\]\W\033[37m]\033[31m\$\[\033[00m\] ";
          echo;
          echo -e "        _           \033[34m__ _       _\033[0m";
          echo -e "       (_)         \033[34m/ _| |     | |\033[0m";
          echo -e "  \033[32m_ __  ___  __\033[37m   \033[34m| |_| | __ _| | _____  ___\033[0m";
          echo -e " \033[32m| '_ \\| \\ \\/ /   \033[34m|  _| |/ _\` | |/ / _ \\/ __|\\033[0m";
          echo -e " \033[32m| | | | |>  < \033[2m\033[46m   \033[0m\033[34m| | | | (_| |   <  __/\\__ \\ \033[0m";
          echo -e " \033[32m|_| |_|_/_/\\_\   \033[34m|_| |_|\__,_|_|\\_\\___||___/\033[0m";
          echo;
          echo "Thank you for using rydnr's Nix Flakes, Nix in general, and appreciating free software!";
          echo;
          echo "My Nix flakes are available at https://github.com/rydnr/nix-flakes and distributed under the GPLv3 license.";
          echo "If you want to financially reward me (although you don't have to),";
          echo "you can do it here: https://patreon.com/rydnr";
          echo;
        '';
        devShell-for = { package, python }:
          pkgs.mkShell {
            buildInputs = [ package ];
            shellHook = shellHook-for {
              package = package;
              python = python;
            };
          };
        pympler-1_0_1-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "Pympler";
            version = "1.0.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-mT8aNZnKP0/NcWDHVFrQYxDJ4S9wF0rnro1OJfbF0/o=";
            };

            doCheck = false;
            meta = with lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = {
          pympler-1_0_1-python38 = pympler-1_0_1-for pkgs.python38;
          pympler-1_0_1-python39 = pympler-1_0_1-for pkgs.python39;
          pympler-1_0_1-python310 = pympler-1_0_1-for pkgs.python310;
          pympler-1_0_1-python311 = pympler-1_0_1-for pkgs.python311;
          pympler-latest-python38 = packages.pympler-1_0_1-python38;
          pympler-latest-python39 = packages.pympler-1_0_1-python39;
          pympler-latest-python310 = packages.pympler-1_0_1-python310;
          pympler-latest-python311 = packages.pympler-1_0_1-python311;
          pympler-latest = packages.pympler-latest-python311;
          default = packages.pympler-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pympler-1_0_1-python38 = devShell-for {
            package = packages.pympler-1_0_1-python38;
            python = pkgs.python38;
          };
          pympler-1_0_1-python39 = devShell-for {
            package = packages.pympler-1_0_1-python39;
            python = pkgs.python39;
          };
          pympler-1_0_1-python310 = devShell-for {
            package = packages.pympler-1_0_1-python310;
            python = pkgs.python310;
          };
          pympler-1_0_1-python311 = devShell-for {
            package = packages.pympler-1_0_1-python311;
            python = pkgs.python311;
          };
          pympler-latest-python38 = devShells.pympler-1_0_1-python38;
          pympler-latest-python39 = devShells.pympler-1_0_1-python39;
          pympler-latest-python310 = devShells.pympler-1_0_1-python310;
          pympler-latest-python311 = devShells.pympler-1_0_1-python311;
          pympler-latest = devShells.pympler-latest-python311;
          default = devShells.pympler-latest;
        };
      });
}

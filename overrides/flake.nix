{
  description =
    "A decorator @override that verifies that a method that should override an inherited method actually does it.";

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
          "A decorator @override that verifies that a method that should override an inherited method actually does it.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/mkorpela/overrides";
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
            shellHook = shellHook-for { inherit package python; };
          };
        overrides-7_3_1-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "overrides";
            version = "7.3.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-i5fGweFoG3jLyUJLE42IDwgDwiVMXrqr3eV7tsYgk/I=";
            };

            doCheck = false;
            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = {
          overrides-7_3_1-python38 = overrides-7_3_1-for pkgs.python38;
          overrides-7_3_1-python39 = overrides-7_3_1-for pkgs.python39;
          overrides-7_3_1-python310 = overrides-7_3_1-for pkgs.python310;
          overrides-7_3_1-python311 = overrides-7_3_1-for pkgs.python311;
          overrides-7_3_1-python312 = overrides-7_3_1-for pkgs.python312;
          overrides-latest-python38 = packages.overrides-7_3_1-python38;
          overrides-latest-python39 = packages.overrides-7_3_1-python39;
          overrides-latest-python310 = packages.overrides-7_3_1-python310;
          overrides-latest-python311 = packages.overrides-7_3_1-python311;
          overrides-latest-python312 = packages.overrides-7_3_1-python312;
          overrides-latest = packages.overrides-latest-python312;
          default = packages.overrides-latest;
        };
        defaultPackage = packages.default;
        devShells = with packages; rec {
          overrides-7_3_1-python38 = devShell-for {
            package = overrides-7_3_1-python38;
            python = pkgs.python38;
          };
          overrides-7_3_1-python39 = devShell-for {
            package = overrides-7_3_1-python39;
            python = pkgs.python39;
          };
          overrides-7_3_1-python310 = devShell-for {
            package = overrides-7_3_1-python310;
            python = pkgs.python310;
          };
          overrides-7_3_1-python311 = devShell-for {
            package = overrides-7_3_1-python311;
            python = pkgs.python311;
          };
          overrides-7_3_1-python312 = devShell-for {
            package = overrides-7_3_1-python312;
            python = pkgs.python312;
          };
          overrides-latest-python38 = overrides-7_3_1-python38;
          overrides-latest-python39 = overrides-7_3_1-python39;
          overrides-latest-python310 = overrides-7_3_1-python310;
          overrides-latest-python311 = overrides-7_3_1-python311;
          overrides-latest-python312 = overrides-7_3_1-python312;
          overrides-latest = overrides-latest-python312;
          default = overrides-latest;
        };
      });
}

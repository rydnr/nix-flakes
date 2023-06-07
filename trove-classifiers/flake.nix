{
  description = "Canonical source for classifiers on PyPI.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description = "Canonical source for classifiers on PyPI.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pypa/trove-classifiers";
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
          echo "These Nix flakes are available at https://github.com/rydnr/nix-flakes and distributed under the GPLv3 license.";
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
        trove-classifiers-2023_5_24-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "trove-classifiers";
            version = "2023.5.24";
            src = python.pkgs.fetchPypi {
              pname = "trove-classifiers";
              version = "2023.5.24";
              sha256 = "sha256-/VoVRig76UH0dUChNb3q6PsmE4CmogTZwYAS8qGwzq4=";
            };

            buildInputs = with python.pkgs; [ calver ];
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        default = packages.trove-classifiers;
        meta = with lib; { inherit description license homepage maintainers; };

      in rec {
        packages = {
          trove-classifiers-2023_5_24-python38 =
            trove-classifiers-2023_5_24-for pkgs.python38;
          trove-classifiers-2023_5_24-python39 =
            trove-classifiers-2023_5_24-for pkgs.python39;
          trove-classifiers-2023_5_24-python310 =
            trove-classifiers-2023_5_24-for pkgs.python310;
          trove-classifiers-2023_5_24-python311 =
            trove-classifiers-2023_5_24-for pkgs.python311;
          trove-classifiers-latest-python38 =
            packages.trove-classifiers-2023_5_24-python38;
          trove-classifiers-latest-python39 =
            packages.trove-classifiers-2023_5_24-python39;
          trove-classifiers-latest-python310 =
            packages.trove-classifiers-2023_5_24-python310;
          trove-classifiers-latest-python311 =
            packages.trove-classifiers-2023_5_24-python311;
          trove-classifiers-latest =
            packages.trove-classifiers-latest-python311;
          default = packages.trove-classifiers-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          trove-classifiers-2023_5_24-python38 = devShell-for {
            package = packages.trove-classifiers-2023_5_24-python38;
            python = pkgs.python38;
          };
          trove-classifiers-2023_5_24-python39 = devShell-for {
            package = packages.trove-classifiers-2023_5_24-python39;
            python = pkgs.python39;
          };
          trove-classifiers-2023_5_24-python310 = devShell-for {
            package = packages.trove-classifiers-2023_5_24-python310;
            python = pkgs.python310;
          };
          trove-classifiers-2023_5_24-python311 = devShell-for {
            package = packages.trove-classifiers-2023_5_24-python311;
            python = pkgs.python311;
          };
          trove-classifiers-latest-python38 =
            trove-classifiers-2023_5_24-python38;
          trove-classifiers-latest-python39 =
            trove-classifiers-2023_5_24-python39;
          trove-classifiers-latest-python310 =
            trove-classifiers-2023_5_24-python310;
          trove-classifiers-latest-python311 =
            trove-classifiers-2023_5_24-python311;
          trove-classifiers-latest = trove-classifiers-latest-python311;
          default = trove-classifiers-latest;
        };
      });
}

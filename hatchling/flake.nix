{
  description = "Hatch is a modern, extensible Python project manager.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    trove-classifiers = {
      url = "path:../trove-classifiers";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "Hatch is a modern, extensible Python project manager.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://hatch.pypa.io/latest/";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
        hatchling-1_17_1-for = { trove-classifiers, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "hatchling";
            version = "1.17.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-dt7lEI+Sm365EC3wob+I+jJH1opE/x85XhzzLqqwxvo=";
            };
            format = "pyproject";

            nativeBuildInputs = [ python.pkgs.build python.pkgs.pathspec ];
            propagatedBuildInputs =
              [ python.pkgs.pluggy python.pkgs.editables trove-classifiers ];
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = rec {
          hatchling-1_17_1-python38 = hatchling-1_17_1-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-2023_5_24-python38;
            python = pkgs.python38;
          };
          hatchling-1_17_1-python39 = hatchling-1_17_1-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-2023_5_24-python39;
            python = pkgs.python39;
          };
          hatchling-1_17_1-python310 = hatchling-1_17_1-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-2023_5_24-python310;
            python = pkgs.python310;
          };
          hatchling-1_17_1-python311 = hatchling-1_17_1-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-2023_5_24-python311;
            python = pkgs.python311;
          };
          hatchling-latest-python38 = hatchling-1_17_1-python38;
          hatchling-latest-python39 = hatchling-1_17_1-python39;
          hatchling-latest-python310 = hatchling-1_17_1-python310;
          hatchling-latest-python311 = hatchling-1_17_1-python311;
          hatchling-latest = hatchling-latest-python311;
          default = hatchling-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          hatchling-1_17_1-python38 = shared.devShell-for {
            package = packages.hatchling-1_17_1-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-1_17_1-python39 = shared.devShell-for {
            package = packages.hatchling-1_17_1-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-1_17_1-python310 = shared.devShell-for {
            package = packages.hatchling-1_17_1-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-1_17_1-python311 = shared.devShell-for {
            package = packages.hatchling-1_17_1-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-latest-python38 = hatchling-1_17_1-python38;
          hatchling-latest-python39 = hatchling-1_17_1-python39;
          hatchling-latest-python310 = hatchling-1_17_1-python310;
          hatchling-latest-python311 = hatchling-1_17_1-python311;
          hatchling-latest = hatchling-latest-python311;
          default = hatchling-latest;
        };
      });
}

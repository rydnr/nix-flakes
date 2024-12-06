{
  description = "Nix flake for hatch";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    trove-classifiers = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:rydnr/nix-flakes/trove-classifiers-2023.5.24.2?dir=trove-classifiers";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description = "Hatch is a modern, extensible Python project manager.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://hatch.pypa.io/latest/";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixpkgs-24.05";
        shared = import ../shared.nix;
        hatchling-for = { trove-classifiers, python }:
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
          default = hatchling-python312;
          hatchling-python39 = hatchling-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-python39;
            python = pkgs.python39;
          };
          hatchling-python310 = hatchling-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-python310;
            python = pkgs.python310;
          };
          hatchling-python311 = hatchling-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-python311;
            python = pkgs.python311;
          };
          hatchling-python312 = hatchling-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-python312;
            python = pkgs.python312;
          };
          hatchling-python313 = hatchling-for {
            trove-classifiers =
              trove-classifiers.packages.${system}.trove-classifiers-python313;
            python = pkgs.python313;
          };
        };
        defaultPackage = packages.default;
        devShells = rec {
          default = hatchling-python312;
          hatchling-python39 = shared.devShell-for {
            package = packages.hatchling-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-python310 = shared.devShell-for {
            package = packages.hatchling-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-python311 = shared.devShell-for {
            package = packages.hatchling-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-python312 = shared.devShell-for {
            package = packages.hatchling-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          hatchling-python313 = shared.devShell-for {
            package = packages.hatchling-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
      });
}

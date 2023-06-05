{
  description = "Hatch is a modern, extensible Python project manager.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    trove-classifiers = {
      url =
        "github:rydnr/nix-flakes/trove-classifiers-2023.5.24?dir=trove-classifiers";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description = "Hatch is a modern, extensible Python project manager.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://hatch.pypa.io/latest/";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          hatchling = pythonPackages.buildPythonPackage rec {
            pname = "hatchling";
            version = "1.17.1";
            src = pythonPackages.fetchPypi {
              pname = "hatchling";
              version = "1.17.1";
              sha256 = "sha256-dt7lEI+Sm365EC3wob+I+jJH1opE/x85XhzzLqqwxvo=";
            };
            format = "pyproject";

            nativeBuildInputs =
              [ pythonPackages.build pythonPackages.pathspec ];
            propagatedBuildInputs = [
              pythonPackages.pluggy
              pythonPackages.editables
              trove-classifiers.packages.${system}.trove-classifiers
            ];
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.hatchling;
          meta = with lib; {
            inherit description license homepage maintainers;
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}

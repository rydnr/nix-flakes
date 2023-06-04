{
  description = "Canonical source for classifiers on PyPI.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
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
      in rec {
        packages = {
          trove-classifiers = pythonPackages.buildPythonPackage rec {
            pname = "trove-classifiers";
            version = "2023.5.24";
            src = pythonPackages.fetchPypi {
              pname = "trove-classifiers";
              version = "2023.5.24";
              sha256 = "sha256-/VoVRig76UH0dUChNb3q6PsmE4CmogTZwYAS8qGwzq4=";
            };

            buildInputs = with pythonPackages; [ calver ];
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.trove-classifiers;
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

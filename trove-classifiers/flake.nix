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
        description = "Canonical source for classifiers on PyPI.";
        license = pkgs.lib.licenses.asl20;
        homepage = "https://github.com/pypa/trove-classifiers";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
        trove-classifiers-2023_5_24-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "trove-classifiers";
            version = "2023.5.24";
            src = python.pkgs.fetchPypi {
              inherit pname version;
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
          trove-classifiers-2023_5_24-python38 = shared.devShell-for {
            package = packages.trove-classifiers-2023_5_24-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-2023_5_24-python39 = shared.devShell-for {
            package = packages.trove-classifiers-2023_5_24-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-2023_5_24-python310 = shared.devShell-for {
            package = packages.trove-classifiers-2023_5_24-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-2023_5_24-python311 = shared.devShell-for {
            package = packages.trove-classifiers-2023_5_24-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
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

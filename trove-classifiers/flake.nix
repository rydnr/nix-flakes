{
  description = "Canonical source for classifiers on PyPI.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
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
        nixpkgsRelease = "nixos-24.05";
        shared = import ../shared.nix;
        trove-classifiers-for = python:
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
        defaultPackage = packages.default;
        devShells = rec {
          trove-classifiers-python38 = shared.devShell-for {
            package = packages.trove-classifiers-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-python39 = shared.devShell-for {
            package = packages.trove-classifiers-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-python310 = shared.devShell-for {
            package = packages.trove-classifiers-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-python311 = shared.devShell-for {
            package = packages.trove-classifiers-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          trove-classifiers-python312 = shared.devShell-for {
            package = packages.trove-classifiers-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          default = trove-classifiers-python312;
        };
        packages = {
          default = packages.trove-classifiers-python312;
          trove-classifiers-python38 =
            trove-classifiers-for pkgs.python38;
          trove-classifiers-python39 =
            trove-classifiers-for pkgs.python39;
          trove-classifiers-python310 =
            trove-classifiers-for pkgs.python310;
          trove-classifiers-python311 =
            trove-classifiers-for pkgs.python311;
          trove-classifiers-python312 =
            trove-classifiers-for pkgs.python312;
        };
      });
}

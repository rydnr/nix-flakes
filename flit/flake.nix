{
  description =
    "Flit is a simple way to put Python packages and modules on PyPI";

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
        description =
          "Flit is a simple way to put Python packages and modules on PyPI";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pypa/flit";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          flit-core = pythonPackages.buildPythonPackage rec {
            pname = "flit";
            version = "3.9.0";
            src = pkgs.fetchFromGitHub {
              owner = "pypa";
              repo = "flit";
              rev = "3.9.0";
              sha256 = "sha256-yl2+PcKr7xRW4oIBWl+gzh/nKhSNu5GH9fWKRGgaNHU=";
            };
            format = "pyproject";
            sourceRoot = "source/flit_core";

            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          flit = pythonPackages.buildPythonPackage rec {
            pname = "flit";
            version = "3.9.0";
            src = pythonPackages.fetchPypi {
              pname = "flit";
              version = "3.9.0";
              sha256 = "sha256-117fXrMk2iDVNXCmpvh/UeYG7ug4SSXNZqkGERQIRMc=";
            };
            format = "pyproject";

            propagatedBuildInputs = with pythonPackages; [
              docutils
              packages.flit-core
              requests
              tomli-w
            ];

            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.flit;
          meta = with lib; {
            inherit description license homepage maintainers;
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [
            packages.default
            packages.flit-core
          ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [
            self.packages.${system}.default
            self.packages.${system}.flit-core
          ];
        };
      });
}

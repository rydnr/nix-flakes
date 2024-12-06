{
  description = "Nix flake for flit";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    trove-classifiers = {
      url = "path:../trove-classifiers";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description =
          "Flit is a simple way to put Python packages and modules on PyPI";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pypa/flit";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixpkgs-24.05";
        shared = import ../shared.nix;
        flit-core-for = python:
          python.pkgs.buildPythonPackage rec {
            pname = "flit";
            version = "3.9.0";
            src = pkgs.fetchFromGitHub {
              owner = "pypa";
              repo = pname;
              rev = version;
              sha256 = "sha256-yl2+PcKr7xRW4oIBWl+gzh/nKhSNu5GH9fWKRGgaNHU=";
            };
            format = "pyproject";
            sourceRoot = "source/flit_core";

            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        flit-for = { flit-core, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "flit";
            version = "3.9.0";

            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-117fXrMk2iDVNXCmpvh/UeYG7ug4SSXNZqkGERQIRMc=";
            };
            format = "pyproject";

            propagatedBuildInputs = with python.pkgs; [
              docutils
              flit-core
              requests
              tomli-w
            ];

            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = flit-python312;
          flit-core-python39 = shared.devShell-for {
            package = packages.flit-core-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-python310 = shared.devShell-for {
            package = packages.flit-core-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-python311 = shared.devShell-for {
            package = packages.flit-core-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-python312 = shared.devShell-for {
            package = packages.flit-core-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-python313 = shared.devShell-for {
            package = packages.flit-core-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
          flit-python39 = shared.devShell-for {
            package = packages.flit-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-python310 = shared.devShell-for {
            package = packages.flit-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-python311 = shared.devShell-for {
            package = packages.flit-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-python312 = shared.devShell-for {
            package = packages.flit-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          flit-python313 = shared.devShell-for {
            package = packages.flit-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = {
          default = packages.flit-python312;
          flit-core-python39 = flit-core-for pkgs.python39;
          flit-core-python310 = flit-core-for pkgs.python310;
          flit-core-python311 = flit-core-for pkgs.python311;
          flit-core-python312 = flit-core-for pkgs.python312;
          flit-core-python313 = flit-core-for pkgs.python313;
          flit-python39 = flit-for {
            flit-core = packages.flit-core-python39;
            python = pkgs.python39;
          };
          flit-python310 = flit-for {
            flit-core = packages.flit-core-python310;
            python = pkgs.python310;
          };
          flit-python311 = flit-for {
            flit-core = packages.flit-core-python311;
            python = pkgs.python311;
          };
          flit-python312 = flit-for {
            flit-core = packages.flit-core-python312;
            python = pkgs.python312;
          };
          flit-python313 = flit-for {
            flit-core = packages.flit-core-python313;
            python = pkgs.python313;
          };
        };
      });
}

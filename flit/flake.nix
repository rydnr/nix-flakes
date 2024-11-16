{
  description =
    "Nix flake for flit";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/24.05";
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
        description =
          "Flit is a simple way to put Python packages and modules on PyPI";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pypa/flit";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
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
        packages = {
          default = packages.flit-python312;
          flit-core-python38 = flit-core-for pkgs.python38;
          flit-core-python39 = flit-core-for pkgs.python39;
          flit-core-python310 = flit-core-for pkgs.python310;
          flit-core-python311 = flit-core-for pkgs.python311;
          flit-core-python312 = flit-core-for pkgs.python312;
          flit-python38 = flit-for {
            flit-core = packages.flit-core-python38;
            python = pkgs.python38;
          };
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
        };
        defaultPackage = packages.default;
        devShells = rec {
          default = flit-python312;
          flit-core-python38 = shared.devShell-for {
            package = packages.flit-core-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
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
          flit-python38 = shared.devShell-for {
            package = packages.flit-python38;
            python = pkgs.python38;
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
        };
      });
}

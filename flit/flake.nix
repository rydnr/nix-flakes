{
  description =
    "Flit is a simple way to put Python packages and modules on PyPI";

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
        description =
          "Flit is a simple way to put Python packages and modules on PyPI";
        license = pkgs.lib.licenses.bsd3;
        homepage = "https://github.com/pypa/flit";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ../shared.nix;
        flit-core-3_9_0-for = python:
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
        flit-3_9_0-for = { flit-core, python }:
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
          flit-core-3_9_0-python38 = flit-core-3_9_0-for pkgs.python38;
          flit-core-3_9_0-python39 = flit-core-3_9_0-for pkgs.python39;
          flit-core-3_9_0-python310 = flit-core-3_9_0-for pkgs.python310;
          flit-core-3_9_0-python311 = flit-core-3_9_0-for pkgs.python311;
          flit-core-latest-python38 = packages.flit-core-3_9_0-python38;
          flit-core-latest-python39 = packages.flit-core-3_9_0-python39;
          flit-core-latest-python310 = packages.flit-core-3_9_0-python310;
          flit-core-latest-python311 = packages.flit-core-3_9_0-python311;
          flit-core-latest = packages.flit-core-latest-python311;
          flit-3_9_0-python38 = flit-3_9_0-for {
            flit-core = packages.flit-core-3_9_0-python38;
            python = pkgs.python38;
          };
          flit-3_9_0-python39 = flit-3_9_0-for {
            flit-core = packages.flit-core-3_9_0-python39;
            python = pkgs.python39;
          };
          flit-3_9_0-python310 = flit-3_9_0-for {
            flit-core = packages.flit-core-3_9_0-python310;
            python = pkgs.python310;
          };
          flit-3_9_0-python311 = flit-3_9_0-for {
            flit-core = packages.flit-core-3_9_0-python311;
            python = pkgs.python311;
          };
          flit-latest-python38 = packages.flit-3_9_0-python38;
          flit-latest-python39 = packages.flit-3_9_0-python39;
          flit-latest-python310 = packages.flit-3_9_0-python310;
          flit-latest-python311 = packages.flit-3_9_0-python311;
          flit-latest = packages.flit-latest-python311;
          default = packages.flit-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          flit-core-3_9_0-python38 = shared.devShell-for {
            package = packages.flit-core-3_9_0-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-3_9_0-python39 = shared.devShell-for {
            package = packages.flit-core-3_9_0-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-3_9_0-python310 = shared.devShell-for {
            package = packages.flit-core-3_9_0-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-3_9_0-python311 = shared.devShell-for {
            package = packages.flit-core-3_9_0-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-core-latest-python38 = flit-core-3_9_0-python38;
          flit-core-latest-python39 = flit-core-3_9_0-python39;
          flit-core-latest-python310 = flit-core-3_9_0-python310;
          flit-core-latest-python311 = flit-core-3_9_0-python311;
          flit-core-latest = flit-core-latest-python311;
          flit-3_9_0-python38 = shared.devShell-for {
            package = packages.flit-3_9_0-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          flit-3_9_0-python39 = shared.devShell-for {
            package = packages.flit-3_9_0-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-3_9_0-python310 = shared.devShell-for {
            package = packages.flit-3_9_0-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-3_9_0-python311 = shared.devShell-for {
            package = packages.flit-3_9_0-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-latest-python38 = flit-3_9_0-python38;
          flit-latest-python39 = flit-3_9_0-python39;
          flit-latest-python310 = flit-3_9_0-python310;
          flit-latest-python311 = flit-3_9_0-python311;
          flit-latest = flit-latest-python311;
          default = flit-latest;
        };
      });
}

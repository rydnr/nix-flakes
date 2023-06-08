{
  description =
    "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit_core to build the package.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "path:../flit";
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
          "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit_core to build the package.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://gitlab.com/WillDaSilva/flit_scm";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
        flit-scm-1_7_0-for = { flit-core, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "flit-scm";
            version = "1.7.0";
            src = pkgs.fetchgit {
              url = "https://gitlab.com/WillDaSilva/flit_scm";
              rev = version;
              sha256 = "sha256-2nx9kWq/2TzauOW+c67g9a3JZ2dhBM4QzKyK/sqWOPo=";
            };
            format = "pyproject";
            nativeBuildInputs = [
              flit-core
              python.pkgs.setuptools_scm
              python.pkgs.tomli
              python.pkgs.wheel
            ];
            SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = {
          flit-scm-1_7_0-python38 = flit-scm-1_7_0-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python38;
            python = pkgs.python38;
          };
          flit-scm-1_7_0-python39 = flit-scm-1_7_0-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python39;
            python = pkgs.python39;
          };
          flit-scm-1_7_0-python310 = flit-scm-1_7_0-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python310;
            python = pkgs.python310;
          };
          flit-scm-1_7_0-python311 = flit-scm-1_7_0-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python311;
            python = pkgs.python311;
          };
          flit-scm-latest-python38 = packages.flit-scm-1_7_0-python38;
          flit-scm-latest-python39 = packages.flit-scm-1_7_0-python39;
          flit-scm-latest-python310 = packages.flit-scm-1_7_0-python310;
          flit-scm-latest-python311 = packages.flit-scm-1_7_0-python311;
          flit-scm-latest = packages.flit-scm-latest-python311;
          default = packages.flit-scm-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          flit-scm-1_7_0-python38 = shared.devShell-for {
            package = packages.flit-scm-1_7_0-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-1_7_0-python39 = shared.devShell-for {
            package = packages.flit-scm-1_7_0-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-1_7_0-python310 = shared.devShell-for {
            package = packages.flit-scm-1_7_0-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-1_7_0-python311 = shared.devShell-for {
            package = packages.flit-scm-1_7_0-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-latest-python38 = flit-scm-1_7_0-python38;
          flit-scm-latest-python39 = flit-scm-1_7_0-python39;
          flit-scm-latest-python310 = flit-scm-1_7_0-python310;
          flit-scm-latest-python311 = flit-scm-1_7_0-python311;
          flit-scm-latest = flit-scm-latest-python311;
          default = flit-scm-latest;
        };
      });
}

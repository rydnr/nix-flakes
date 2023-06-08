{
  description =
    "This is a backport of the BaseExceptionGroup and ExceptionGroup classes from Python 3.11.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "path:../flit";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    flit-scm = {
      url = "path:../flit-scm";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description =
          "This is a backport of the BaseExceptionGroup and ExceptionGroup classes from Python 3.11.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://github.com/agronholm/exceptiongroup";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./shared.nix;
        exceptiongroup-1_1_1-for = { flit, flit-scm, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "exceptiongroup";
            version = "1.1.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-1ITDCQuiiJrikoQZEXRHoU2vPBIx1eMNCq4081TwF4U=";
            };
            format = "pyproject";

            nativeBuildInputs = [ flit flit-scm python.pkgs.setuptools-scm ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        packages = rec {
          exceptiongroup-1_1_1-python38 = exceptiongroup-1_1_1-for {
            flit = flit.packages.${system}.flit-3_9_0-python38;
            flit-scm = flit-scm.packages.${system}.flit-scm-1_7_0-python38;
            python = pkgs.python38;
          };
          exceptiongroup-1_1_1-python39 = exceptiongroup-1_1_1-for {
            flit = flit.packages.${system}.flit-3_9_0-python39;
            flit-scm = flit-scm.packages.${system}.flit-scm-1_7_0-python39;
            python = pkgs.python39;
          };
          exceptiongroup-1_1_1-python310 = exceptiongroup-1_1_1-for {
            flit = flit.packages.${system}.flit-3_9_0-python310;
            flit-scm = flit-scm.packages.${system}.flit-scm-1_7_0-python310;
            python = pkgs.python310;
          };
          exceptiongroup-1_1_1-python311 = exceptiongroup-1_1_1-for {
            flit = flit.packages.${system}.flit-3_9_0-python311;
            flit-scm = flit-scm.packages.${system}.flit-scm-1_7_0-python311;
            python = pkgs.python311;
          };
          exceptiongroup-latest-python38 = exceptiongroup-1_1_1-python38;
          exceptiongroup-latest-python39 = exceptiongroup-1_1_1-python39;
          exceptiongroup-latest-python310 = exceptiongroup-1_1_1-python310;
          exceptiongroup-latest-python311 = exceptiongroup-1_1_1-python311;
          exceptiongroup-latest = exceptiongroup-latest-python311;
          default = exceptiongroup-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          exceptiongroup-1_1_1-python38 = shared.devShell-for {
            package = packages.exceptiongroup-1_1_1-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-1_1_1-python39 = shared.devShell-for {
            package = packages.exceptiongroup-1_1_1-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-1_1_1-python310 = shared.devShell-for {
            package = packages.exceptiongroup-1_1_1-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-1_1_1-python311 = shared.devShell-for {
            package = packages.exceptiongroup-1_1_1-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-latest-python38 = exceptiongroup-1_1_1-python38;
          exceptiongroup-latest-python39 = exceptiongroup-1_1_1-python39;
          exceptiongroup-latest-python310 = exceptiongroup-1_1_1-python310;
          exceptiongroup-latest-python311 = exceptiongroup-1_1_1-python311;
          exceptiongroup-latest = exceptiongroup-latest-python311;
          default = exceptiongroup-latest;
        };
      });
}

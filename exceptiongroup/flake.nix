{
  description = "Nix flake for exceptiongroup";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/flit-3.9.0.3?dir=flit";
    };
    flit-scm = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/flit-scm-1.7.0.1?dir=flit-scm";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description =
          "This is a backport of the BaseExceptionGroup and ExceptionGroup classes from Python 3.11.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://github.com/agronholm/exceptiongroup";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixpkgs-23.05";
        shared = import ../shared.nix;
        exceptiongroup-for = { flit, flit-scm, python }:
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
          default = exceptiongroup-python312;
          exceptiongroup-python39 = exceptiongroup-for {
            flit = flit.packages.${system}.flit-python39;
            flit-scm = flit-scm.packages.${system}.flit-scm-python39;
            python = pkgs.python39;
          };
          exceptiongroup-python310 = exceptiongroup-for {
            flit = flit.packages.${system}.flit-python310;
            flit-scm = flit-scm.packages.${system}.flit-scm-python310;
            python = pkgs.python310;
          };
          exceptiongroup-python311 = exceptiongroup-for {
            flit = flit.packages.${system}.flit-python311;
            flit-scm = flit-scm.packages.${system}.flit-scm-python311;
            python = pkgs.python311;
          };
          exceptiongroup-python312 = exceptiongroup-for {
            flit = flit.packages.${system}.flit-python312;
            flit-scm = flit-scm.packages.${system}.flit-scm-python312;
            python = pkgs.python312;
          };
          exceptiongroup-python313 = exceptiongroup-for {
            flit = flit.packages.${system}.flit-python313;
            flit-scm = flit-scm.packages.${system}.flit-scm-python313;
            python = pkgs.python313;
          };
        };
        defaultPackage = packages.default;
        devShells = rec {
          default = exceptiongroup-exceptiongroup-python312;
          exceptiongroup-python39 = shared.devShell-for {
            package = packages.exceptiongroup-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-python310 = shared.devShell-for {
            package = packages.exceptiongroup-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-python311 = shared.devShell-for {
            package = packages.exceptiongroup-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-python312 = shared.devShell-for {
            package = packages.exceptiongroup-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          exceptiongroup-python313 = shared.devShell-for {
            package = packages.exceptiongroup-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
      });
}

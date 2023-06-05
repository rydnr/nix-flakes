{
  description =
    "This is a backport of the BaseExceptionGroup and ExceptionGroup classes from Python 3.11.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "github:rydnr/nix-flakes/flit-3.9.0?dir=flit";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    flit-scm = {
      url = "github:rydnr/nix-flakes/flit-scm-1.7.0?dir=flit-scm";
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
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description =
          "This is a backport of the BaseExceptionGroup and ExceptionGroup classes from Python 3.11.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://github.com/agronholm/exceptiongroup";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          exceptiongroup = pythonPackages.buildPythonPackage rec {
            pname = "exceptiongroup";
            version = "1.1.1";
            src = pythonPackages.fetchPypi {
              pname = "exceptiongroup";
              version = "1.1.1";
              sha256 = "sha256-1ITDCQuiiJrikoQZEXRHoU2vPBIx1eMNCq4081TwF4U=";
            };
            format = "pyproject";

            nativeBuildInputs = [
              flit-scm.packages.${system}.flit-scm
              flit.packages.${system}.flit-core
              pythonPackages.setuptools-scm
            ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.exceptiongroup;
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

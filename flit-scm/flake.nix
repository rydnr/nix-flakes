{
  description =
    "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit_core to build the package.";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      url = "github:rydnr/nix-flakes/flit-3.9.0?dir=flit";
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
          "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit_core to build the package.";
        license = pkgs.lib.licenses.mit;
        homepage = "https://gitlab.com/WillDaSilva/flit_scm";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          flit-scm = pythonPackages.buildPythonPackage rec {
            pname = "flit-scm";
            version = "1.7.0";
            src = pkgs.fetchgit {
              url = "https://gitlab.com/WillDaSilva/flit_scm";
              rev = "1.7.0";
              sha256 = "sha256-2nx9kWq/2TzauOW+c67g9a3JZ2dhBM4QzKyK/sqWOPo=";
            };
            format = "pyproject";
            nativeBuildInputs = [
              flit.packages.${system}.flit-core
              pythonPackages.setuptools_scm
              pythonPackages.tomli
              pythonPackages.wheel
            ];
            SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.flit-scm;
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

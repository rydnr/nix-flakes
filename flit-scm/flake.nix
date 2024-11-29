{
  description = "Nix flake for flit-scm";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:rydnr/nix-flakes/flit-3.9.0.1?dir=flit";
    };
    nixos.url = "github:NixOS/nixpkgs/24.05";
    tomli = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.flit.follows = "flit";
      inputs.nixos.follows = "nixos";
      url = "github:rydnr/nix-flakes/tomli-2.0.1.1?dir=tomli";
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
        shared = import ../shared.nix;
        flit-scm-for = { flit-core, tomli, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "flit-scm";
            version = "1.7.0";
            src = pkgs.fetchgit {
              url = "https://gitlab.com/WillDaSilva/flit_scm";
              rev = version;
              sha256 = "sha256-2nx9kWq/2TzauOW+c67g9a3JZ2dhBM4QzKyK/sqWOPo=";
            };
            format = "pyproject";
            nativeBuildInputs =
              [ flit-core python.pkgs.setuptools_scm tomli python.pkgs.wheel ];
            SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";
            doCheck = false;

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = flit-scm-latest;
          flit-scm-python39 = shared.devShell-for {
            package = packages.flit-scm-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-python310 = shared.devShell-for {
            package = packages.flit-scm-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-python311 = shared.devShell-for {
            package = packages.flit-scm-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-python312 = shared.devShell-for {
            package = packages.flit-scm-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          flit-scm-python313 = shared.devShell-for {
            package = packages.flit-scm-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = {
          default = packages.flit-scm-python312;
          flit-scm-python39 = flit-scm-for {
            flit-core = flit.packages.${system}.flit-core-python39;
            tomli = tomli.packages.${system}.tomli-python39;
            python = pkgs.python39;
          };
          flit-scm-python310 = flit-scm-for {
            flit-core = flit.packages.${system}.flit-core-python310;
            tomli = tomli.packages.${system}.tomli-python310;
            python = pkgs.python310;
          };
          flit-scm-python311 = flit-scm-for {
            flit-core = flit.packages.${system}.flit-core-python311;
            tomli = tomli.packages.${system}.tomli-python311;
            python = pkgs.python311;
          };
          flit-scm-python312 = flit-scm-for {
            flit-core = flit.packages.${system}.flit-core-python312;
            tomli = tomli.packages.${system}.tomli-python312;
            python = pkgs.python312;
          };
          flit-scm-python313 = flit-scm-for {
            flit-core = flit.packages.${system}.flit-core-python313;
            tomli = tomli.packages.${system}.tomli-python313;
            python = pkgs.python313;
          };
        };
      });
}

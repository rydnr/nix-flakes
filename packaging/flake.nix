{
  description = "Nix flake for packaging";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url= "github:rydnr/nix-flakes/flit-3.9.0.3?dir=flit";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        description = "Reusable core utilities for various Python Packaging interoperability specifications.";
        license = pkgs.lib.licenses.bsd;
        homepage = "https://packaging.pypa.io/";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ../shared.nix;
        packaging-for = { flit-core, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "packaging";
            version = "25.0";
            format = "pyproject";
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-1EOHLJjWd79g9qHy+MHLdI6P52LSv50xSLVZkpWw/E8=";
            };
            nativeBuildInputs = [ setuptools wheel ];
            propagatedBuildInputs = with python.pkgs; [
              flit-core
            ];
            doCheck = false;
            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = packaging-python312;
          packaging-python39 = shared.devShell-for {
            package = packages.packaging-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          packaging-python310 = shared.devShell-for {
            package = packages.packaging-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          packaging-python311 = shared.devShell-for {
            package = packages.packaging-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          packaging-python312 = shared.devShell-for {
            package = packages.packaging-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          packaging-python313 = shared.devShell-for {
            package = packages.packaging-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = packaging-python312;
          packaging-python39 = packaging-for {
            python = pkgs.python39;
            flit-core = flit.packages.${system}.flit-core-python39;
          };
          packaging-python310= packaging-for {
            python = pkgs.python310;
            flit-core = flit.packages.${system}.flit-core-python310;
          };
          packaging-python311 = packaging-for {
            python = pkgs.python311;
            flit-core = flit.packages.${system}.flit-core-python311;
          };
          packaging-python312 = packaging-for {
            python = pkgs.python312;
            flit-core = flit.packages.${system}.flit-core-python312;
          };
          packaging-python313 = packaging-for {
            python = pkgs.python313;
            flit-core = flit.packages.${system}.flit-core-python313;
          };
        };
      });
}

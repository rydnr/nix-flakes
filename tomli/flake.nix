{
  description = "Nix flake for hukkin/tomli";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    flit = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:rydnr/nix-flakes/flit-3.9.0.1?dir=flit";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "A lil' TOML parser";
        license = pkgs.lib.licenses.mit;
        homepage = "https://github.com/hukkin/tomli";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-24.05";
        shared = import ../shared.nix;
        tomli-for = { flit-core, python }:
          python.pkgs.buildPythonPackage rec {
            pname = "tomli";
            version = "2.0.1";
            src = python.pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-3lJsEpFPDFUNFZJMYtcqvEjW/nNkqocygzejEAf+ik8=";
            };
            format = "pyproject";

            nativeBuildInputs = [ flit-core ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = tomli-python312;
          tomli-python39 = shared.devShell-for {
            package = packages.tomli-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          tomli-python310 = shared.devShell-for {
            package = packages.tomli-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          tomli-python311 = shared.devShell-for {
            package = packages.tomli-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          tomli-python312 = shared.devShell-for {
            package = packages.tomli-python312;
            python = pkgs.python312;
            inherit pkgs nixpkgsRelease;
          };
          tomli-python313 = shared.devShell-for {
            package = packages.tomli-python313;
            python = pkgs.python313;
            inherit pkgs nixpkgsRelease;
          };
        };
        packages = rec {
          default = packages.tomli-python312;
          tomli-python39 = tomli-for {
            flit-core = flit.packages.${system}.flit-core-python39;
            python = pkgs.python39;
          };
          tomli-python310 = tomli-for {
            flit-core = flit.packages.${system}.flit-core-python310;
            python = pkgs.python310;
          };
          tomli-python311 = tomli-for {
            flit-core = flit.packages.${system}.flit-core-python311;
            python = pkgs.python311;
          };
          tomli-python312 = tomli-for {
            flit-core = flit.packages.${system}.flit-core-python312;
            python = pkgs.python312;
          };
          tomli-python313 = tomli-for {
            flit-core = flit.packages.${system}.flit-core-python313;
            python = pkgs.python313;
          };
        };
      });
}

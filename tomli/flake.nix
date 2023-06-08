{
  description = "A lil' TOML parser";

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
        description = "A lil' TOML parser";
        license = pkgs.lib.licenses.mit;
        homepage = "https://github.com/hukkin/tomli";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ../shared.nix;
        tomli-2_0_1-for = { flit-core, python }:
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
        packages = rec {
          tomli-2_0_1-python38 = tomli-2_0_1-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python38;
            python = pkgs.python38;
          };
          tomli-2_0_1-python39 = tomli-2_0_1-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python39;
            python = pkgs.python39;
          };
          tomli-2_0_1-python310 = tomli-2_0_1-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python310;
            python = pkgs.python310;
          };
          tomli-2_0_1-python311 = tomli-2_0_1-for {
            flit-core = flit.packages.${system}.flit-core-3_9_0-python311;
            python = pkgs.python311;
          };
          tomli-latest-python38 = tomli-2_0_1-python38;
          tomli-latest-python39 = tomli-2_0_1-python39;
          tomli-latest-python310 = tomli-2_0_1-python310;
          tomli-latest-python311 = tomli-2_0_1-python311;
          tomli-latest = tomli-latest-python311;
          default = packages.tomli-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          tomli-2_0_1-python38 = shared.devShell-for {
            package = packages.tomli-2_0_1-python38;
            python = pkgs.python38;
            inherit pkgs nixpkgsRelease;
          };
          tomli-2_0_1-python39 = shared.devShell-for {
            package = packages.tomli-2_0_1-python39;
            python = pkgs.python39;
            inherit pkgs nixpkgsRelease;
          };
          tomli-2_0_1-python310 = shared.devShell-for {
            package = packages.tomli-2_0_1-python310;
            python = pkgs.python310;
            inherit pkgs nixpkgsRelease;
          };
          tomli-2_0_1-python311 = shared.devShell-for {
            package = packages.tomli-2_0_1-python311;
            python = pkgs.python311;
            inherit pkgs nixpkgsRelease;
          };
          tomli-latest-python38 = tomli-2_0_1-python38;
          tomli-latest-python39 = tomli-2_0_1-python39;
          tomli-latest-python310 = tomli-2_0_1-python310;
          tomli-latest-python311 = tomli-2_0_1-python311;
          tomli-latest = tomli-latest-python311;
          default = tomli-latest;
        };
      });
}
